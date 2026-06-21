from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List
from app.models.post import PostStatus


class PostBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    content: str
    summary: Optional[str] = None
    tags: Optional[List[str]] = None
    status: PostStatus = PostStatus.draft


class PostCreate(PostBase):
    pass


class PostUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    content: Optional[str] = None
    summary: Optional[str] = None
    tags: Optional[List[str]] = None
    status: Optional[PostStatus] = None


class PostResponse(PostBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class PostSearch(BaseModel):
    query: str
    tags: Optional[List[str]] = None
    status: Optional[PostStatus] = None
