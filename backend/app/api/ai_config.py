import httpx
import logging
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.schemas.ai_config import (
    AIConfigCreate,
    AIConfigUpdate,
    AIConfigResponse,
)
from app.models.ai_config import AIConfig

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get("/api/ai/config/active")
def get_active_config(db: Session = Depends(get_db)):
    """获取当前活跃的 AI 配置（取最新一条）"""
    config = db.query(AIConfig).order_by(AIConfig.updated_at.desc()).first()
    if not config:
        # 返回空配置，让前端使用环境变量
        return {
            "provider": "deepseek",
            "apiKey": "",
            "model": "deepseek-chat",
            "baseURL": "https://api.deepseek.com/v1",
            "systemPrompt": "你是一个友好的博客 AI 助手。",
            "temperature": 0.7,
            "maxTokens": 2000,
        }

    return {
        "provider": config.provider,
        "apiKey": config.api_key,
        "model": config.model,
        "baseURL": _get_base_url(config.provider),
        "systemPrompt": config.system_prompt or "你是一个友好的博客 AI 助手。",
        "temperature": config.temperature,
        "maxTokens": config.max_tokens,
    }


@router.get("/api/ai/config", response_model=list[AIConfigResponse])
def list_configs(db: Session = Depends(get_db)):
    return db.query(AIConfig).all()


@router.get("/api/ai/config/{config_id}", response_model=AIConfigResponse)
def get_config(config_id: int, db: Session = Depends(get_db)):
    config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not config:
        raise HTTPException(status_code=404, detail="AI config not found")
    return config


@router.post("/api/ai/config", response_model=AIConfigResponse, status_code=201)
def create_config(config: AIConfigCreate, db: Session = Depends(get_db)):
    try:
        db_config = AIConfig(**config.model_dump())
        db.add(db_config)
        db.commit()
        db.refresh(db_config)
        return db_config
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create config: {str(e)}")


@router.put("/api/ai/config", response_model=AIConfigResponse)
def update_or_create_config(config: AIConfigUpdate, db: Session = Depends(get_db)):
    """更新或创建配置（总是更新最新的一条）"""
    db_config = db.query(AIConfig).order_by(AIConfig.updated_at.desc()).first()

    if not db_config:
        # 没有配置时创建新的
        create_data = config.model_dump(exclude_unset=True)
        db_config = AIConfig(
            provider=create_data.get("provider", "deepseek"),
            api_key=create_data.get("api_key", ""),
            model=create_data.get("model", "deepseek-chat"),
            system_prompt=create_data.get("system_prompt"),
            temperature=create_data.get("temperature", 0.7),
            max_tokens=create_data.get("max_tokens", 2000),
        )
        db.add(db_config)
    else:
        update_data = config.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_config, key, value)

    try:
        db.commit()
        db.refresh(db_config)
        return db_config
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to save config: {str(e)}")


@router.put("/api/ai/config/{config_id}", response_model=AIConfigResponse)
def update_config_by_id(
    config_id: int, config: AIConfigUpdate, db: Session = Depends(get_db)
):
    db_config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not db_config:
        raise HTTPException(status_code=404, detail="AI config not found")

    try:
        update_data = config.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_config, key, value)

        db.commit()
        db.refresh(db_config)
        return db_config
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to update config: {str(e)}")


@router.delete("/api/ai/config/{config_id}")
def delete_config(config_id: int, db: Session = Depends(get_db)):
    db_config = db.query(AIConfig).filter(AIConfig.id == config_id).first()
    if not db_config:
        raise HTTPException(status_code=404, detail="AI config not found")

    try:
        db.delete(db_config)
        db.commit()
        return {"message": "AI config deleted"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to delete config: {str(e)}")


@router.post("/api/ai/config/test")
async def test_connection(db: Session = Depends(get_db)):
    """测试 AI 配置的连接"""
    config = db.query(AIConfig).order_by(AIConfig.updated_at.desc()).first()
    if not config:
        raise HTTPException(status_code=400, detail="No AI config found")

    base_url = _get_base_url(config.provider)
    api_key = config.api_key

    if not api_key:
        return {"success": False, "message": "API Key 未配置"}

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{base_url.rstrip('/')}/chat/completions",
                headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
                json={
                    "model": config.model,
                    "messages": [{"role": "user", "content": "hi"}],
                    "max_tokens": 10,
                },
                timeout=15.0,
            )

            if response.status_code == 200:
                return {"success": True, "message": "连接成功！"}
            else:
                error_detail = response.text[:200]
                return {"success": False, "message": f"连接失败: {error_detail}"}
    except httpx.TimeoutException:
        return {"success": False, "message": "连接超时，请检查网络和配置"}
    except Exception as e:
        return {"success": False, "message": f"连接失败: {str(e)}"}


def _get_base_url(provider: str) -> str:
    """根据供应商返回 API base URL"""
    urls = {
        "deepseek": "https://api.deepseek.com/v1",
        "openai": "https://api.openai.com/v1",
        "qwen": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "anthropic": "https://api.anthropic.com/v1",
    }
    return urls.get(provider.lower(), "https://api.openai.com/v1")
