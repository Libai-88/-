from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.schemas.embedding import RAGSearch
from app.models.post import Post, PostStatus
from app.services.rag import RAGService

router = APIRouter()
rag_service = RAGService()


@router.post("/api/rag/search")
async def rag_search(
    search: RAGSearch,
    db: Session = Depends(get_db),
):
    embeddings = await rag_service.search_similar_posts(
        db, query=search.query, limit=search.limit
    )

    results = []
    for emb in embeddings:
        post = db.query(Post).filter(Post.id == emb.post_id).first()
        if post and post.status == PostStatus.published:
            results.append(
                {
                    "id": post.id,
                    "title": post.title,
                    "summary": post.summary,
                    "tags": post.tags,
                    "content_preview": emb.content[:500],
                    "created_at": post.created_at,
                    "updated_at": post.updated_at,
                }
            )

    return {"query": search.query, "results": results, "total": len(results)}
