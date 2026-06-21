from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.ai_config import (
    AIConfigCreate,
    AIConfigUpdate,
    AIConfigResponse,
)
from app.models.ai_config import AIConfig

router = APIRouter()


@router.get("/api/ai/config", response_model=List[AIConfigResponse])
def list_configs(db: Session = Depends(get_db)):
    return db.query(AIConfig).all()


@router.get("/api/ai/config/{config_id}", response_model=AIConfigResponse)
def get_config(config_id: int, db: Session = Depends(get_db)):
    config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not config:
        raise HTTPException(status_code=404, detail="AI config not found")
    return config


@router.post("/api/ai/config", response_model=AIConfigResponse)
def create_config(config: AIConfigCreate, db: Session = Depends(get_db)):
    db_config = AIConfig(**config.model_dump())
    db.add(db_config)
    db.commit()
    db.refresh(db_config)
    return db_config


@router.put("/api/ai/config/{config_id}", response_model=AIConfigResponse)
def update_config(
    config_id: int, config: AIConfigUpdate, db: Session = Depends(get_db)
):
    db_config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not db_config:
        raise HTTPException(status_code=404, detail="AI config not found")

    update_data = config.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_config, key, value)

    db.commit()
    db.refresh(db_config)
    return db_config


@router.delete("/api/ai/config/{config_id}")
def delete_config(config_id: int, db: Session = Depends(get_db)):
    db_config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not db_config:
        raise HTTPException(status_code=404, detail="AI config not found")

    db.delete(db_config)
    db.commit()
    return {"message": "AI config deleted"}
