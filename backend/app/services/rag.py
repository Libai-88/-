import json
import httpx
import logging
from typing import List
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.core.config import get_settings
from app.models.embedding import PostEmbedding
from app.models.post import Post, PostStatus

logger = logging.getLogger(__name__)

settings = get_settings()
_IS_SQLITE = settings.DATABASE_URL.startswith("sqlite")


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
        embedding_value = await self.generate_embedding(text)

        # SQLite stores embedding as JSON string
        if _IS_SQLITE:
            embedding_value = json.dumps(embedding_value)

        existing = (
            db.query(PostEmbedding).filter(PostEmbedding.post_id == post.id).first()
        )
        if existing:
            existing.embedding = embedding_value
            existing.content = text
            db.commit()
            db.refresh(existing)
            return existing

        db_embedding = PostEmbedding(
            post_id=post.id,
            content=text,
            embedding=embedding_value,
        )
        db.add(db_embedding)
        db.commit()
        db.refresh(db_embedding)
        return db_embedding

    async def search_similar_posts(
        self, db: Session, query: str, limit: int = 10
    ) -> List[PostEmbedding]:
        """通过向量相似度搜索相关文章（SQLite 降级为文本搜索）"""
        if _IS_SQLITE:
            return self._sqlite_text_search(db, query, limit)

        if not self.api_key:
            return self._sqlite_text_search(db, query, limit)

        try:
            query_embedding = await self.generate_embedding(query)
        except Exception as e:
            logger.error(f"Failed to generate query embedding: {e}")
            return self._sqlite_text_search(db, query, limit)

        if not query_embedding:
            return self._sqlite_text_search(db, query, limit)

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
            return self._sqlite_text_search(db, query, limit)

    def _sqlite_text_search(
        self, db: Session, query: str, limit: int
    ) -> List[PostEmbedding]:
        """SQLite 降级方案：文本相似度搜索"""
        search_term = f"%{query}%"
        embeddings = (
            db.query(PostEmbedding)
            .filter(
                or_(
                    PostEmbedding.content.like(search_term),
                    PostEmbedding.content.like(f"%{query}%"),
                )
            )
            .limit(limit)
            .all()
        )

        if not embeddings:
            # 如果没有向量数据，直接返回空（让 API 层 fallback 到全文搜索）
            return []

        return embeddings
