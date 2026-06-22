import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import init_db
from app.api.posts import router as posts_router
from app.api.rag import router as rag_router
from app.api.ai_config import router as ai_config_router

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """应用生命周期管理"""
    # Startup
    logger.info("Initializing database...")
    try:
        init_db()
        logger.info("Database initialized successfully")
    except Exception as e:
        logger.warning(f"Database initialization failed (will retry on first request): {e}")
    yield
    # Shutdown
    logger.info("Shutting down...")


app = FastAPI(
    title="Kirameku Blog API",
    description="Blog API with AI/RAG capabilities",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(posts_router)
app.include_router(rag_router)
app.include_router(ai_config_router)


@app.get("/health")
def health_check():
    return {"status": "ok", "version": "1.0.0"}
