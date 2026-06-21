from pydantic import BaseModel, Field


class RAGSearch(BaseModel):
    query: str = Field(..., min_length=1, description="Search query text")
    limit: int = Field(default=10, ge=1, le=100, description="Maximum number of results")
