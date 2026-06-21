# Kirameku - AI Blog System

> A beautiful frosted-glass style blog with an embedded AI Agent, powered by Vercel AI SDK.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Next.js 14 / React 18 / Tailwind CSS / Framer Motion |
| **AI SDK** | Vercel AI SDK v4 / @ai-sdk/openai |
| **Backend** | FastAPI / Python 3.10+ / SQLAlchemy |
| **Database** | PostgreSQL 14+ / pgvector |
| **Admin** | Vue 3 / Element Plus / Vite |

## Features

- **AI Chat Agent** - Natural conversation with your blog content
- **RAG Knowledge Base** - pgvector-powered semantic search for relevant blog posts
- **Tool Calling** - AI can search posts, get stats, create drafts
- **Multi-Model Support** - DeepSeek, OpenAI, Qwen, Anthropic, and more
- **Frosted Glass UI** - Beautiful glassmorphism design with animations
- **Admin Dashboard** - Vue-based admin panel with AI configuration
- **Free Deployment** - Vercel + Render + Supabase = $0 hosting

## Quick Start

### 1. Prerequisites

- Node.js 18+ (recommended 20 LTS)
- Python 3.10+
- PostgreSQL 14+ (with pgvector extension)
- An AI provider API Key (recommended: DeepSeek)

### 2. Clone & Setup

```bash
cd frontend && npm install && cp .env.example .env.local
cd ../backend && python -m venv venv && source venv/bin/activate && pip install -r requirements.txt
cd ../admin && npm install
```

### 3. Database Setup

```bash
# Create database
createdb kirameku

# Initialize tables
psql -d kirameku -f backend/database/init.sql
```

### 4. Configure Environment

**Frontend** (`frontend/.env.local`):
```env
BACKEND_URL=http://localhost:8000
DEEPSEEK_API_KEY=your-api-key-here
```

**Backend** (`backend/.env`):
```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/kirameku
DEEPSEEK_API_KEY=your-api-key-here
```

### 5. Run Development Servers

```bash
# Backend (port 8000)
cd backend && uvicorn app.main:app --reload

# Frontend (port 3000)
cd frontend && npm run dev

# Admin (port 3001)
cd admin && npm run dev
```

Visit:
- Blog: http://localhost:3000
- Admin: http://localhost:3001
- API Docs: http://localhost:8000/docs

## Project Structure

```
Kirameku/
├── frontend/              # Next.js frontend + AI API
│   ├── app/
│   │   ├── api/chat/      # AI chat endpoint
│   │   │   ├── route.ts   # Chat API handler
│   │   │   └── tools.ts   # AI tool definitions
│   │   └── (blog)/        # Blog pages
│   ├── components/ai-chat/ # Chat UI components
│   └── lib/ai/            # AI configuration
├── backend/               # FastAPI backend
│   ├── app/
│   │   ├── api/           # API routes (posts, RAG, config)
│   │   ├── models/        # SQLAlchemy models
│   │   ├── schemas/       # Pydantic schemas
│   │   └── services/rag.py # RAG vector service
│   └── database/init.sql  # Database init script
└── admin/                 # Vue 3 admin panel
    └── src/views/
        ├── Dashboard.vue  # Stats dashboard
        ├── Posts.vue      # Post management
        └── AIConfig.vue   # AI provider configuration
```

## AI Features

### Chat
Click the chat button (bottom-right) to talk with the AI assistant. It uses RAG to answer questions based on your blog content.

### Tools
The AI can:
- **Search posts** - Find relevant blog articles
- **Get post details** - Read full article content
- **Get blog stats** - View statistics
- **Create drafts** - Write article drafts (requires review)

### Configuration
Go to the admin panel (`/admin`) to configure:
- AI provider (DeepSeek, OpenAI, Qwen, etc.)
- API Key
- Model name
- System prompt
- Temperature & max tokens

## Deployment

| Service | Platform | Cost |
|---------|----------|------|
| Frontend | Vercel | Free |
| Backend | Render / Railway | Free tier |
| Database | Supabase / Neon | Free tier |
| Admin | Vercel / Netlify | Free |

**Total cost: ~$0-1/month** (just AI API usage)

## Cost Estimate

With DeepSeek (recommended):
- Input: ¥0.5 / 1M tokens
- Output: ¥1 / 1M tokens
- Personal blog usage: ~¥2-5/month

## License

MIT
