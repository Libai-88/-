from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, String
from typing import List, Optional
from app.core.database import get_db
from app.schemas.post import (
    PostCreate,
    PostUpdate,
    PostResponse,
    PostSearch,
)
from app.models.post import Post, PostStatus

router = APIRouter()


@router.get("/api/posts", response_model=List[PostResponse])
def list_posts(
    status: Optional[PostStatus] = None,
    tag: Optional[str] = None,
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(Post).filter(Post.status == PostStatus.published)
    if tag:
        # PostgreSQL JSONB contains; fallback compatible
        query = query.filter(Post.tags.cast(String).contains(tag))
    return (
        query.order_by(Post.created_at.desc()).offset(offset).limit(limit).all()
    )


@router.get("/api/posts/{post_id}", response_model=PostResponse)
def get_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post


@router.post("/api/posts", response_model=PostResponse, status_code=201)
def create_post(post: PostCreate, db: Session = Depends(get_db)):
    try:
        db_post = Post(**post.model_dump())
        db.add(db_post)
        db.commit()
        db.refresh(db_post)
        return db_post
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create post: {str(e)}")


@router.put("/api/posts/{post_id}", response_model=PostResponse)
def update_post(post_id: int, post: PostUpdate, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")

    try:
        update_data = post.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_post, key, value)

        db.commit()
        db.refresh(db_post)
        return db_post
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to update post: {str(e)}")


@router.delete("/api/posts/{post_id}", status_code=200)
def delete_post(post_id: int, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")

    try:
        db.delete(db_post)
        db.commit()
        return {"message": "Post deleted"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to delete post: {str(e)}")


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


@router.post("/api/posts/draft", response_model=PostResponse, status_code=201)
def create_draft(post: PostCreate, db: Session = Depends(get_db)):
    """创建文章草稿"""
    try:
        draft = Post(
            title=post.title,
            content=post.content,
            summary=post.summary,
            tags=post.tags or [],
            status=PostStatus.draft,
        )
        db.add(draft)
        db.commit()
        db.refresh(draft)
        return draft
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create draft: {str(e)}")


@router.post("/api/posts/search", response_model=List[PostResponse])
def search_posts(
    search: PostSearch,
    db: Session = Depends(get_db),
):
    query = db.query(Post).filter(Post.status == PostStatus.published)

    if search.status:
        query = query.filter(Post.status == search.status)

    if search.tags:
        for tag in search.tags:
            query = query.filter(Post.tags.cast(String).contains(tag))

    if search.query:
        search_term = f"%{search.query}%"
        query = query.filter(
            or_(
                Post.title.ilike(search_term),
                Post.content.ilike(search_term),
                Post.summary.ilike(search_term),
            )
        )

    return query.order_by(Post.updated_at.desc()).limit(50).all()


@router.get("/api/stats")
def get_stats(db: Session = Depends(get_db)):
    """获取博客统计数据"""
    total_posts = db.query(Post).filter(Post.status == PostStatus.published).count()
    total_drafts = db.query(Post).filter(Post.status == PostStatus.draft).count()

    # 获取所有标签
    all_posts = db.query(Post).filter(Post.status == PostStatus.published).all()
    tag_set = set()
    for p in all_posts:
        if p.tags:
            tag_set.update(p.tags)

    return {
        "total_posts": total_posts,
        "total_drafts": total_drafts,
        "total_tags": len(tag_set),
        "tags": list(tag_set),
    }


@router.get("/api/tags", response_model=List[str])
def get_tags(db: Session = Depends(get_db)):
    """获取所有标签"""
    all_posts = db.query(Post).filter(Post.status == PostStatus.published).all()
    tag_set = set()
    for p in all_posts:
        if p.tags:
            tag_set.update(p.tags)
    return sorted(list(tag_set))
