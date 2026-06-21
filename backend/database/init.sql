-- Kirameku Blog Database Initialization Script
-- Run this after creating the database: psql -d kirameku -f init.sql

-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Posts table
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    summary TEXT,
    tags JSONB DEFAULT '[]',
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('published', 'draft')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Post embeddings table (for RAG)
CREATE TABLE IF NOT EXISTS post_embeddings (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    content TEXT,
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create IVFFLAT index for fast vector search
CREATE INDEX IF NOT EXISTS post_embeddings_embedding_idx 
ON post_embeddings 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- AI configuration table
CREATE TABLE IF NOT EXISTS ai_config (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(50) NOT NULL DEFAULT 'deepseek',
    api_key VARCHAR(255) NOT NULL DEFAULT '',
    model VARCHAR(100) NOT NULL DEFAULT 'deepseek-chat',
    system_prompt TEXT DEFAULT '你是一个友好的博客 AI 助手，擅长回答关于博客内容的问题。回答要友好、自然、简洁。',
    temperature FLOAT DEFAULT 0.7,
    max_tokens INTEGER DEFAULT 2000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stats table (optional, for tracking blog statistics)
CREATE TABLE IF NOT EXISTS blog_stats (
    id SERIAL PRIMARY KEY,
    total_views BIGINT DEFAULT 0,
    total_likes BIGINT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tags table (optional, for better tag management)
CREATE TABLE IF NOT EXISTS tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default AI config
INSERT INTO ai_config (provider, api_key, model, system_prompt)
VALUES ('deepseek', '', 'deepseek-chat', '你是一个友好的博客 AI 助手，擅长回答关于博客内容的问题。回答要友好、自然、简洁。')
ON CONFLICT DO NOTHING;

-- Insert default stats
INSERT INTO blog_stats (total_views, total_likes)
VALUES (0, 0)
ON CONFLICT DO NOTHING;

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at
CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_post_embeddings_updated_at BEFORE UPDATE ON post_embeddings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ai_config_updated_at BEFORE UPDATE ON ai_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
