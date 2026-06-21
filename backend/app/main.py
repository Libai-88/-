from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.database import init_db
from app.api.posts import router as posts_router
from app.api.rag import router as rag_router
from app.api.ai_config import router as ai_config_router


app = FastAPI(
    title="Kirameku Blog API",
    description="Blog API with AI/RAG capabilities",
    version="1.0.0",
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


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/health")
def health_check():
    return {"status": "ok"}
