import httpx
import logging
from typing import List, Optional
from sqlalchemy.orm import Session
from app.core.config import get_settings
from app.models.embedding import PostEmbedding
from app.models.post import Post

logger = logging.getLogger(__name__)

settings = get_settings()


class RAGService:
    def __init__(self):
        self.api_base = settings.EMBEDDING_API_BASE.rstrip("/")
        self.api_key = settings.EMBEDDING_API_KEY
        self.model = settings.EMBEDDING_MODEL
        self.dimensions = settings.EMBEDDING_DIMENSIONS

    async def generate_embedding(self, text: str) -> List[float]:
        """生成文本的向量表示"""
        if not self.api_key:
            raise ValueError("EMBEDDING_API_KEY is not configured")

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }
        payload = {"input": text, "model": self.model}

        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.api_base}/embeddings",
                json=payload,
                headers=headers,
                timeout=30.0,
            )
            response.raise_for_status()
            data = response.json()

            if not data.get("data"):
                raise ValueError("Invalid embedding response: no data")

            return data["data"][0]["embedding"]

    async def create_post_embedding(
        self, db: Session, post: Post, text: str
    ) -> PostEmbedding:
        """为文章创建或更新向量"""
        embedding_vector = await self.generate_embedding(text)

        existing = (
            db.query(PostEmbedding).filter(PostEmbedding.post_id == post.id).first()
        )
        if existing:
            existing.embedding = embedding_vector
            existing.content = text
            db.commit()
            db.refresh(existing)
            return existing

        db_embedding = PostEmbedding(
            post_id=post.id,
            content=text,
            embedding=embedding_vector,
        )
        db.add(db_embedding)
        db.commit()
        db.refresh(db_embedding)
        return db_embedding

    async def search_similar_posts(
        self, db: Session, query: str, limit: int = 10
    ) -> List[PostEmbedding]:
        """通过向量相似度搜索相关文章"""
        try:
            query_embedding = await self.generate_embedding(query)
        except Exception as e:
            logger.error(f"Failed to generate query embedding: {e}")
            return []

        if not query_embedding:
            return []

        try:
            results = (
                db.query(PostEmbedding)
                .order_by(PostEmbedding.embedding.cosine_distance(query_embedding))
                .limit(limit)
                .all()
            )
            return results
        except Exception as e:
            logger.error(f"Vector search failed: {e}")
            return []
