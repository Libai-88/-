from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional


class AIConfigBase(BaseModel):
    provider: str = Field(..., min_length=1, max_length=100)
    api_key: str = Field(..., min_length=1)
    model: str = Field(..., min_length=1, max_length=255)
    system_prompt: Optional[str] = None
    temperature: float = Field(default=0.7, ge=0.0, le=2.0)
    max_tokens: int = Field(default=1000, ge=1)


class AIConfigCreate(AIConfigBase):
    pass


class AIConfigUpdate(BaseModel):
    provider: Optional[str] = Field(None, min_length=1, max_length=100)
    api_key: Optional[str] = Field(None, min_length=1)
    model: Optional[str] = Field(None, min_length=1, max_length=255)
    system_prompt: Optional[str] = None
    temperature: Optional[float] = Field(None, ge=0.0, le=2.0)
    max_tokens: Optional[int] = Field(None, ge=1)


class AIConfigResponse(AIConfigBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
