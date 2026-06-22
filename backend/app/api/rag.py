import logging
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.schemas.embedding import RAGSearch
from app.models.post import Post, PostStatus
from app.models.embedding import PostEmbedding
from app.services.rag import RAGService

logger = logging.getLogger(__name__)

router = APIRouter()
rag_service = RAGService()


@router.post("/api/rag/search")
async def rag_search(
    search: RAGSearch,
    db: Session = Depends(get_db),
):
    """RAG 语义搜索相关文章"""
    try:
        embeddings = await rag_service.search_similar_posts(
            db, query=search.query, limit=search.limit
        )
    except Exception as e:
        logger.error(f"RAG search failed: {e}")
        # 如果 RAG 不可用，降级为文本搜索
        results = _fallback_text_search(db, search.query, search.limit)
        return {"query": search.query, "results": results, "total": len(results), "method": "text_fallback"}

    results = []
    for emb in embeddings:
        post = db.query(Post).filter(Post.id == emb.post_id).first()
        if post and post.status == PostStatus.published:
            content_preview = emb.content[:500] if emb.content else ""
            results.append(
                {
                    "id": post.id,
                    "title": post.title,
                    "summary": post.summary or "",
                    "tags": post.tags or [],
                    "content": emb.content or "",
                    "content_preview": content_preview,
                    "created_at": post.created_at,
                    "updated_at": post.updated_at,
                }
            )

    return {"query": search.query, "results": results, "total": len(results), "method": "vector"}


def _fallback_text_search(db: Session, query: str, limit: int) -> list:
    """降级方案：文本相似度搜索（当向量搜索不可用时）"""
    from sqlalchemy import or_

    search_term = f"%{query}%"
    posts = (
        db.query(Post)
        .filter(
            Post.status == PostStatus.published,
            or_(
                Post.title.ilike(search_term),
                Post.summary.ilike(search_term),
                Post.content.ilike(search_term),
            )
        )
        .limit(limit)
        .all()
    )

    return [
        {
            "id": p.id,
            "title": p.title,
            "summary": p.summary or "",
            "tags": p.tags or [],
            "content": p.content[:500] if p.content else "",
            "content_preview": p.content[:500] if p.content else "",
            "created_at": p.created_at,
            "updated_at": p.updated_at,
        }
        for p in posts
    ]
