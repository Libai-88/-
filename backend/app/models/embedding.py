from sqlalchemy import Column, Integer, Text, DateTime, ForeignKey, String
from sqlalchemy.sql import func
from app.core.database import Base
from app.core.config import get_settings

settings = get_settings()

def _is_sqlite() -> bool:
    return settings.DATABASE_URL.startswith("sqlite")


class PostEmbedding(Base):
    __tablename__ = "post_embeddings"

    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id", ondelete="CASCADE"), nullable=False)
    content = Column(Text, nullable=False)

    # Use Vector for PostgreSQL, JSON string for SQLite
    if _is_sqlite():
        embedding = Column(String, nullable=False)  # Store as JSON string
    else:
        from pgvector.sqlalchemy import Vector
        embedding = Column(Vector(1536), nullable=False)

    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    if not _is_sqlite():
        __table_args__ = (
            Index(
                "ix_post_embeddings_embedding",
                "embedding",
                postgresql_using="ivfflat",
                postgresql_with={"lists": 100},
            ),
        )
