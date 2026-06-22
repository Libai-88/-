# Kirameku 部署指南

> 使用免费方案部署：Vercel（前端）+ Render（后端）+ Supabase（数据库）

## 一、部署架构

```
用户浏览器
    │
    ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Vercel        │────▶│   Render        │────▶│   Supabase      │
│  (Next.js 前端) │     │  (FastAPI 后端) │     │  (PostgreSQL)   │
│  免费 Hobby     │     │  免费 Web       │     │  免费 500MB     │
│  100GB/月      │     │  750小时/月     │     │  pgvector       │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**总成本：0 元/月**（仅 AI API 调用费用约 2-5 元/月）

---

## 二、前置准备

1. **GitHub 账号**（用于代码托管和自动部署）
2. **Vercel 账号**（用 GitHub 登录）
3. **Render 账号**（用 GitHub 登录，无需信用卡）
4. **Supabase 账号**（用 GitHub 登录）
5. **AI API Key**（推荐 DeepSeek，注册即送额度）

---

## 三、第一步：创建 Supabase 数据库

### 3.1 创建项目
1. 访问 [supabase.com](https://supabase.com)，登录后点击 "New Project"
2. 填写项目名称：`kirameku-blog`
3. 选择地区：Asia Pacific (Singapore) 或 Asia Pacific (Mumbai)
4. 数据库密码：设置一个强密码并保存
5. 点击 "Create new project"，等待约 2 分钟

### 3.2 启用 pgvector 扩展
1. 进入项目 Dashboard
2. 左侧菜单：Database > Extensions
3. 搜索 `vector`，点击 Enable
4. 确认 `pgvector` 已启用

### 3.3 执行初始化 SQL
1. 左侧菜单：SQL Editor
2. 点击 "New query"
3. 复制粘贴 `/backend/database/init.sql` 的全部内容
4. 点击 "Run" 执行

### 3.4 获取连接字符串
1. 左侧菜单：Project Settings > Database
2. 找到 "Connection string" 区域
3. 选择 URI 格式，复制连接字符串
4. 格式类似：`postgresql://postgres:[密码]@db.xxx.supabase.co:5432/postgres`

---

## 四、第二步：部署后端到 Render

### 4.1 推送代码到 GitHub
```bash
# 在项目根目录初始化 Git（如果还没有）
git init
git add .
git commit -m "Initial commit"

# 创建 GitHub 仓库并推送
git remote add origin https://github.com/你的用户名/kirameku.git
git push -u origin main
```

### 4.2 在 Render 创建 Web Service
1. 访问 [dashboard.render.com](https://dashboard.render.com)
2. 点击 "New" -> "Web Service"
3. 连接你的 GitHub 仓库，选择 `kirameku`
4. 配置如下：

| 配置项 | 值 |
|--------|-----|
| Name | `kirameku-backend` |
| Region | Singapore 或 closest to you |
| Branch | `main` |
| Root Directory | `backend` |
| Runtime | `Python 3` |
| Build Command | `pip install -r requirements.txt` |
| Start Command | `uvicorn app.main:app --host 0.0.0.0 --port $PORT` |

5. 点击 "Advanced" 添加环境变量：

| 环境变量 | 值 | 说明 |
|----------|-----|------|
| `DATABASE_URL` | `postgresql://postgres:xxx@db.xxx.supabase.co:5432/postgres` | Supabase 连接字符串 |
| `EMBEDDING_API_KEY` | `sk-xxx` | DeepSeek API Key |
| `EMBEDDING_API_BASE` | `https://api.deepseek.com/v1` | 嵌入模型 API 地址 |
| `EMBEDDING_MODEL` | `text-embedding-ada-002` | 嵌入模型名称 |
| `EMBEDDING_DIMENSIONS` | `1536` | 向量维度 |

6. 点击 "Create Web Service"
7. 等待部署完成，记录分配的 URL（如 `https://kirameku-backend.onrender.com`）

> Render 免费实例 15 分钟无访问会自动休眠，首次访问有 30-60 秒冷启动时间。测试阶段这是正常的。

---

## 五、第三步：部署前端到 Vercel

### 5.1 导入项目
1. 访问 [vercel.com](https://vercel.com)，用 GitHub 登录
2. 点击 "Add New Project"
3. 导入 `kirameku` 仓库
4. 配置如下：

| 配置项 | 值 |
|--------|-----|
| Framework Preset | Next.js |
| Root Directory | `frontend` |
| Build Command | `npm run build`（默认） |
| Output Directory | `.next`（默认） |

### 5.2 配置环境变量
在 Vercel 项目设置中，添加以下环境变量：

| 环境变量 | 值 |
|----------|-----|
| `NEXT_PUBLIC_BACKEND_URL` | `https://kirameku-backend.onrender.com` |
| `BACKEND_URL` | `https://kirameku-backend.onrender.com` |

### 5.3 部署
点击 "Deploy"，等待约 2-3 分钟完成构建。

部署成功后，Vercel 会分配一个域名，如 `https://kirameku-xxx.vercel.app`。

---

## 六、第四步：配置 CORS（重要）

后端需要允许前端域名访问。更新 Render 的环境变量：

在 Render Dashboard 中，给 `kirameku-backend` 添加：

```
CORS_ORIGINS=https://kirameku-xxx.vercel.app
```

然后修改 `backend/app/main.py` 中的 CORS 配置：

```python
from app.core.config import get_settings
settings = get_settings()

origins = settings.CORS_ORIGINS.split(",") if settings.CORS_ORIGINS else ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

提交代码后 Render 会自动重新部署。

---

## 七、第五步：配置 AI（管理后台）

### 7.1 访问管理后台
1. 打开前端页面
2. 点击右下角 AI 聊天按钮测试
3. 如果提示 "AI 服务未配置 API Key"，说明部署成功，只是需要配置 AI

### 7.2 配置 AI Provider
由于管理后台是独立项目，目前有两种方式配置 AI：

**方式一：直接修改数据库（推荐）**
在 Supabase SQL Editor 中执行：
```sql
UPDATE ai_config
SET provider = 'deepseek',
    api_key = '你的 DeepSeek API Key',
    model = 'deepseek-chat',
    system_prompt = '你是一个友好的博客 AI 助手。'
WHERE id = 1;
```

**方式二：调用 API**
```bash
curl -X PUT https://kirameku-backend.onrender.com/api/ai/config \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "deepseek",
    "api_key": "你的 API Key",
    "model": "deepseek-chat"
  }'
```

---

## 八、Docker 本地部署（可选）

如果你想在本地用 Docker 一键启动所有服务：

```bash
# 1. 设置 AI API Key
export EMBEDDING_API_KEY=你的 DeepSeek API Key

# 2. 启动所有服务
docker-compose up --build

# 3. 访问
# 前端: http://localhost:3000
# 后端 API: http://localhost:8000/docs
# 数据库: localhost:5432
```

停止服务：
```bash
docker-compose down
```

---

## 九、免费额度说明

| 服务 | 免费额度 | 注意事项 |
|------|----------|----------|
| Vercel Hobby | 100GB/月带宽，100万 Function 调用 | 个人项目足够 |
| Render Free | 750小时/月，100GB 带宽 | 15分钟无访问休眠，30-60秒冷启动 |
| Supabase Free | 500MB 存储，2GB 带宽 | 项目 7 天无活动会暂停，手动恢复即可 |
| DeepSeek API | 新用户有免费额度 | 之后约 0.5-1 元/百万 token |

**省钱建议：**
- Render 免费实例休眠后首次访问慢，可以用 UptimeRobot 每 10 分钟 ping 一次保持活跃（不推荐滥用）
- Supabase 项目如果 7 天无活动会暂停，定期访问一下即可
- AI API 费用很低，个人博客一个月通常不到 5 元

---

## 十、常见问题

### Q1: Render 后端启动慢怎么办？
Render 免费实例有冷启动问题。升级 Basic 计划（$6/月）即可解决。

### Q2: Supabase 数据库连接不上？
检查 DATABASE_URL 是否正确，特别是密码部分。Supabase 密码不能包含 `@` 等特殊字符，如果有需要 URL encode。

### Q3: 前端调用后端报 CORS 错误？
确认 `CORS_ORIGINS` 环境变量包含了前端域名。或者临时设置为 `*` 允许所有来源（仅测试用）。

### Q4: AI 聊天没有响应？
1. 检查后端日志是否有错误
2. 确认 `ai_config` 表中有正确的 API Key
3. 测试后端健康检查：`curl https://你的后端地址/health`

### Q5: 如何更新代码？
推送到 GitHub 后，Vercel 和 Render 都会自动重新部署。

---

## 十一、升级建议

当免费额度不够用时：

| 升级项 | 方案 | 费用 |
|--------|------|------|
| Render 冷启动 | 升级到 Basic 实例 | $6/月 |
| 数据库容量 | Supabase Pro | $25/月 |
| Vercel 带宽 | 升级到 Pro | $20/月 |
| 自定义域名 | 购买 .top/.xyz 域名 | ~10元/年 |

即使全部升级，总费用也只需约 $50/月（约 350 元），对于个人项目来说非常划算。
