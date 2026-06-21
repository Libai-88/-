from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.schemas.post import (
    PostCreate,
    PostUpdate,
    PostResponse,
    PostSearch,
)
from app.models.post import Post, PostStatus
from app.services.rag import RAGService

router = APIRouter()
rag_service = RAGService()


@router.get("/api/posts", response_model=List[PostResponse])
def list_posts(
    status: Optional[PostStatus] = None,
    tag: Optional[str] = None,
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(Post)
    if status:
        query = query.filter(Post.status == status)
    if tag:
        query = query.filter(Post.tags.contains([tag]))
    return (
        query.order_by(Post.created_at.desc()).offset(offset).limit(limit).all()
    )


@router.get("/api/posts/{post_id}", response_model=PostResponse)
def get_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post


@router.post("/api/posts", response_model=PostResponse)
def create_post(post: PostCreate, db: Session = Depends(get_db)):
    db_post = Post(**post.model_dump())
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post


@router.put("/api/posts/{post_id}", response_model=PostResponse)
def update_post(post_id: int, post: PostUpdate, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")

    update_data = post.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_post, key, value)

    db.commit()
    db.refresh(db_post)
    return db_post


@router.delete("/api/posts/{post_id}")
def delete_post(post_id: int, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")

    db.delete(db_post)
    db.commit()
    return {"message": "Post deleted"}


@router.get("/api/posts/draft", response_model=List[PostResponse])
def list_drafts(
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
):
    return (
        db.query(Post)
        .filter(Post.status == PostStatus.draft)
        .order_by(Post.updated_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )


@router.post("/api/posts/search", response_model=List[PostResponse])
def search_posts(
    search: PostSearch,
    db: Session = Depends(get_db),
):
    query = db.query(Post)
    if search.status:
        query = query.filter(Post.status == search.status)
    if search.tags:
        for tag in search.tags:
            query = query.filter(Post.tags.contains([tag]))
    if search.query:
        query = query.filter(
            Post.title.ilike(f"%{search.query}%")
            | Post.content.ilike(f"%{search.query}%")
            | Post.summary.ilike(f"%{search.query}%")
        )
    return query.order_by(Post.updated_at.desc()).limit(50).all()
