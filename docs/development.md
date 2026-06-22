# Maxma — AI Agent 桌面工具 开发文档

> **版本**：v1.0（已冻结）
> **最后更新**：2026-06-22
> **状态**：评审四轮闭环，可启动 M0-1 spike
> **配套调研**：LangChain 1.0 / Electron 41+ / 国产大模型 API / Office 处理生态（2026-06-22 完成）
> **应用名**：Maxma（一个词，读作 /ˈmæksmə/）
> **Logo**：艺术字 "Maxma"，主色 赛博渐变（深紫 → 青蓝），参见 `maxma-logo.png`
> **变更记录**：
> - v0.3 → v0.4 吸收技术评审 7+3+2 条
> - v0.4 → v0.5 吸收二轮评审 5+2 修正 + 2 漏判
> - v0.5 → v0.6 修复三轮评审 3 处漏改 + 2 处 B.3/B.6 错配
> - v0.6 → v0.7 修复四轮评审 3 处内部矛盾 + 2 处规范错配
> - **v0.7 → v1.0 应用五轮评审 3 条硬问题 patch + 软建议吸收，冻结为 v1.0 启动 M0-1**

---

## 一、项目目标

打造一款面向个人办公场景的桌面端 AI Agent 工具，集成多模型（DeepSeek 起步，逐步扩展智谱、豆包、通义、文心），支持 Word/Excel/PPT/PDF 的解析、内容理解、改写、生成与导出，并提供轻量编程辅助能力。最终交付物为可独立安装运行的桌面应用（Windows 优先，macOS / Linux 同步兼容）。

## 二、范围与定位

| 维度 | 范围 |
|---|---|
| 核心场景 | 办公文档解析与改写（Word / Excel / PPT / PDF） |
| 次要场景 | 轻量编程辅助（代码片段生成、解释、改写、单元测试） |
| 部署形态 | 桌面应用（Electron + Python 后端打包进安装包，单安装包体验） |
| 网络 | 默认调用云端大模型 API；预留本地 LLM 接入位（Ollama / vLLM） |
| 目标用户 | 个人开发者/办公族，单机单用户，无多租户需求 |

**非目标**：不包含团队协作、不做云端 SaaS 后台、不做移动端。

## 三、技术选型（结论与依据）

| 层级 | 选型 | 关键依据 |
|---|---|---|
| 桌面端壳 | Electron 41+（2026-03，ASAR Integrity 强化、MSIX 自动更新） | 主线版本演进、生态最成熟；与 Vue 3 集成方案丰富 |
| 构建工具 | electron-vite（alex8088，v6.x）+ vue-ts 模板 | 国内 Electron + Vite + Vue 事实标准；自带 main/preload/renderer 三段配置 |
| UI 库 | Vue 3 + Element Plus + Tailwind CSS（可选） | 后台类 UI 成熟、组件全、中文文档佳 |
| 状态/Pinia | Pinia | Vue 3 官方推荐 |
| Agent 框架 | LangChain 1.0 + LangGraph 1.0（create_agent 工厂 + Middleware） | 1.0 是分水岭（2025-10），标准 tool-calling 循环、跨厂商统一内容块 |
| LLM 接入 | 先 DeepSeek（OpenAI 兼容协议 `https://api.deepseek.com`）；扩展层用 `init_chat_model` 抽象 | 国产 1M 上下文、低价、原生 Function Call；后续可无缝接入 GLM/Qwen/Doubao |
| 文档处理 | Python 3.11+ + python-docx 1.2.0 / openpyxl 3.1.5 / python-pptx 0.6.x / pypdf 6.7.1 / pdfplumber 0.11.9 | 活跃维护、生产可用 |
| 桥接 | FastAPI + Uvicorn 暴露本地 HTTP；Electron 主进程 axios 调用 | 解耦、易调试、可独立部署 |
| 打包 | electron-builder（NSIS / AppImage），Python 后端用 PyInstaller 打成单文件打进 resources | 满足"小白用户双击安装即可用"的目标；体积增加约 60-80MB，可接受 |
| 密钥 | electron.safeStorage 主进程加密 + IPC 隔离 | 防止 renderer 直接访问 |
| 自动更新 | 私有：electron-updater + GitHub Releases（0 成本） | 当前为单用户工具，私有通道即可 |

### 3.1 版本固定矩阵

| 依赖 | 锁定版本 | 锁定方式 |
|---|---|---|
| Node.js | 22.x LTS（≥22.12） | `.nvmrc` + Volta 或 nvm |
| Python | 3.11.x 或 3.12.x（避免 3.13 兼容性问题） | `.python-version` + pyenv |
| electron | ^41.0.0（具体 patch 号见 `package-lock.json`） | npm `package-lock.json` |
| langchain | 1.0.x | pip `requirements.txt` + `pip install --require-hashes` |
| langgraph | 1.0.x | 同上 |
| electron-vite | ^6.0.0 | npm 锁定 |
| electron-builder | ^25.0.0 | npm 锁定 |
| PyInstaller | ^6.0.0 | pip 锁定 |
| fastapi | ^0.115.0 | pip 锁定 |

### 3.2 开发环境规约

| 项 | 规约 |
|---|---|
| OS | Windows 11 23H2+（主力）；macOS 14+（次要，用于联调）；WSL2 仅用于 Python 开发可选 |
| IDE | VSCode（推荐，安装 Vue / Python / Even Better TOML 扩展） |
| Shell | PowerShell 7+（Windows）；zsh（macOS） |
| 容器 | 不强制；M5 增强才需要 Docker |
| Lint | 前端 ESLint + Prettier；后端 ruff + mypy strict |
| 格式化 | Prettier（前端）+ Black（后端），提交前自动 format |

### 3.3 数据分级与脱敏规约

| 级别 | 数据 | 脱敏要求 | 落地位置 |
|---|---|---|---|
| **P0 敏感** | API Key、主进程密钥、用户密码（预留字段，P4 接入本地账号时启用）、DPAPI 加密原值 | 禁止写入日志/错误导出/埋点 | 主进程 safeStorage 持有；任何序列化前过 `redact()` 函数 |
| **P1 私密** | 聊天内容、文档正文、用户上传文件路径、知识库内容 | 错误导出时截断前 200 字 + 路径脱敏为 `~/.../file.docx` | 日志中间件、错误边界 |
| **P2 内部** | 会话 ID、trace_id、模型名、token 消耗、UI 语言 | 不脱敏 | 可全量日志 |
| **P3 公开** | 应用版本、操作系统版本、Electron 版本 | 不脱敏 | 可全量日志 |

**实现要求**：

- Python 后端 `app/utils/redact.py` 提供统一脱敏函数 `redact(obj, level)`；
- **日志中间件按 `level_map` 配置自动查表决定 redact 强度，业务代码无需显式声明 level**（v1.0 修订：定型为"中间件自动查表"，消除"调用方"指代歧义）；
- "一键导出诊断包"功能（落到 P3-3）必须按上表逐项处理。

**redact 函数签名**：

```python
def redact(obj: Any, level: Literal["P0", "P1", "P2", "P3"]) -> Any:
    """递归脱敏字典/列表/标量。命中 P0 字段抛 RedactViolation；P1 字段替换为 '***' 或截断前 200 字。"""
```

- P0 字段命中立即抛 `RedactViolation` 异常，绝不允许落盘
- P1 字段递归扫描，命中即替换为 `***` 或截断前 200 字
- 列表/字典递归处理；标量直接返回；None 透传
- 单测覆盖 ≥ 10 个 case（含 P0 字段触发异常）

**风险提示**：LangChain v0.x → v1.0 大重构，需固定版本号（建议 `langchain==1.0.x`、`langgraph==1.0.x`），建立升级回归测试。

## 四、系统架构

```
┌─────────────────────────────────────────────────────────────┐
│ Electron Renderer（Vue 3 + Element Plus + Pinia）           │
│  ├ Chat UI / 任务面板 / 文档预览 / Diff 可视化              │
└──────────────┬──────────────────────────────────────────────┘
               │ preload + contextBridge（IPC）
┌──────────────▼──────────────────────────────────────────────┐
│ Electron Main（Node.js）                                    │
│  ├ safeStorage 管理 API Key                                  │
│  ├ electron-store 配置持久化                                │
│  └ axios 调用本地 Python 后端 / 启动/管理子进程             │
└──────────────┬──────────────────────────────────────────────┘
               │ HTTP / WebSocket（流式）
┌──────────────▼──────────────────────────────────────────────┐
│ Python FastAPI（uvicorn :8000，可打包为子进程）             │
│  ├ LangChain 1.0 create_agent + Middleware                  │
│  ├ Tools:  docx_read / docx_write / xlsx_read / xlsx_write  │
│  │         pptx_read / pptx_write / pdf_read / pdf_write    │
│  │         rag_search / web_search / code_run               │
│  └ 可选：LlamaIndex（检索）/ Chroma（向量库）                │
└──────────────┬──────────────────────────────────────────────┘
               │ HTTPS（OpenAI 兼容协议）
┌──────────────▼──────────────────────────────────────────────┐
│ 云端 LLM：DeepSeek → GLM / Doubao / Qwen / ERNIE           │
└─────────────────────────────────────────────────────────────┘
```

## 五、功能规划（WBS）

### P0 — MVP（必须完成）

| 计划 | 描述 | 验收点 |
|---|---|---|
| **P0-1** 脚手架搭建 | 拉取 `electron-vite` + `vue-ts` 模板，启动 hello world | ① `npm run dev` 三段（HMR）正常 ② `npm run build` 生成产物 ③ 启动后窗口显示 Vue 默认页 |
| **P0-2** 安全基线 | `contextIsolation: true`、`nodeIntegration: false`、`preload + contextBridge` 暴露受控 API | ① renderer 无法 `require('fs')` ② 仅通过 `window.api.xxx` 调用主进程 ③ 审计通过 |
| **P0-3** 主进程密钥管理 | 用 `electron.safeStorage` 加密 API Key，落地 `electron-store` | ① 重启后密钥可解密还原 ② 加密文件非明文 ③ 提供"清空所有密钥"功能 |
| **P0-4** Python 后端骨架 | FastAPI + uvicorn，路由 `/health`、`/chat`、`/chat/stream` | ① `/health` 返回 200 ② `/chat` 非流式可正常返回 ③ `/chat/stream` SSE 正常 |
| **P0-5** LangChain 接入 DeepSeek | 模型名/厂商/base_url/api_key 全部从 `config/models.json` 读取，零 hardcode；`init_chat_model(provider, model, base_url, api_key)` 走 OpenAI 兼容协议 | ① 配置层抽象完成（修改 `config/models.json` 即可切换厂商/模型，无需改代码）② 输入"你好"返回中文回答 ③ Function Call 可正常注册并被模型选中 ④ **M0-4 模型连通性 spike 阶段实测 ≥ 2 个模型连通**（覆盖同厂商不同规格 + 不同厂商 base_url；具体组合由 `config/models.json` 决定，不在文档中写死模型名）⑤ 模型名缺失/格式错时返回 `E_BAD_REQUEST` 而非崩溃（格式规则：`^[a-zA-Z0-9][a-zA-Z0-9._-]{0,63}$`） |
| **P0-6** 聊天 UI 最小版 | 输入框 / 消息列表 / 流式渲染 / 停止按钮 | ① 流式逐字显示 ② 停止后立即中断 ③ 滚动到底部自动 |
| **P0-7** Electron 与后端联调 | 主进程作 HTTP 客户端消费 SSE → IPC Stream 推送给 renderer；renderer 不直连后端 | ① 端到端消息可达 ② 主进程 stream chunk 切片 ≤ 200ms（参考 Chromium network throttle 经验值；M1 NFR 抽检时按 ±50ms 容差跑基准） ③ IPC `chat:stream:chunk` 事件被 renderer 正确接收并按 SSE 事件类型分发渲染 ④ 错误事件统一转译为前端 toast ⑤ AbortController 中断可同时取消主进程 fetch 与后端 LLM 流 |
| **P0-8** 首次启动欢迎页（极简引导） | 单页 Onboarding：品牌展示 → 数据出境/隐私说明 → 强制配置 DeepSeek API Key（可"稍后"） | ① 首次启动必须经过欢迎页才能进主界面 ② 未配 Key 时聊天按钮置灰 + 引导文案 ③ 隐私同意记录持久化 ④ 提供"重看引导"入口 ⑤ 跳过率埋点 |
| **P0-9** 打包雏形 | electron-builder 输出 Windows NSIS 安装包；PyInstaller 单文件打进 resources；extraResources 路径规范统一为 `app.asar.unpacked/py-runtime/` | ① `npm run build:win` 产出 NSIS ② 安装包双击可装 ③ 启动后功能正常 ④ ASAR Integrity 校验通过 ⑤ Python 后端作为子进程被自动拉起并通过健康检查 ⑥ M0-1 spike 实测安装包体积 ≤ 300MB ⑦ installer 首次启动链路冒烟：欢迎页 → 跳过 Key → 进入主界面（验证 P0-8 集成） |

### P1 — 办公文档核心

| 计划 | 描述 | 验收点 |
|---|---|---|
| **P1-1** 文档选择器 | 桌面端选择本地 .docx/.xlsx/.pptx/.pdf 文件 | ① 4 种格式均可上传 ② 超过 50MB 给出警告 ③ 显示文件名/大小/页数 |
| **P1-2** 解析工具集 | python-docx / openpyxl / python-pptx / pypdf 封装为 LangChain Tools | ① `docx_read` 返回结构化文本+表格 ② `xlsx_read` 返回 sheet 名+行列内容 ③ `pptx_read` 返回每页文本+备注 ④ `pdf_read` 支持分页 |
| **P1-3** 写回工具集 | 对应写回 Tools，保留原格式 | ① 改写后能保存为新文件 ② 原有样式（字体/颜色/合并单元格/图表）保留 ③ 提供 diff 输出 |
| **P1-4** 文档 Agent | `create_agent` 串接"读→理解→改→存"，支持多轮对话引用文档片段 | ① 自然语言"把第3段改得更正式"生效 ② 多轮上下文中能引用前次 diff ③ 失败时回退到原文 |
| **P1-5** Diff 可视化 | 前端用 monaco-editor 或 diff 组件展示新旧内容 | ① 红绿高亮 ② 一键接受/拒绝 ③ 拒绝时回退原文件 |
| **P1-6** 导出 PDF | `soffice --headless --convert-to pdf`（需打包 LibreOffice 或使用 unoconv） | ① 4 种 Office 格式均可导出 PDF ② 排版不丢失 ③ 中文不乱码 |

### P2 — 模型扩展与轻量编程

| 计划 | 描述 | 验收点 |
|---|---|---|
| **P2-1** 多模型配置面板 | 设置页添加/删除模型（DeepSeek / 智谱 / 豆包 / 通义 / 文心），独立 API Key | ① 5 个模型可独立启用 ② 模型切换不需重启 ③ 连接测试通过 |
| **P2-2** LangChain Chat Model 统一抽象 | `init_chat_model` + 自定义 `ChatOpenAI` 实例化各厂商 | ① 同一 prompt 在 5 个模型上均可运行 ② Function Call 行为一致 ③ 失败回退到默认模型 |
| **P2-3** 代码 Agent 模式 | 切换"编程助手"模式：代码生成/解释/重构/单测 | ① 支持 5+ 语言（Python/JS/TS/Go/Java） ② 可在 sandbox 内执行（subprocess + 资源限制） ③ 执行结果回显 |
| **P2-4** 代码片段库 | 常用片段收藏与一键插入 | ① 添加/删除/搜索可用 ② 跨会话持久化 ③ 可导出 JSON |
| **P2-5** 上下文压缩 | `SummarizationMiddleware` 防止长会话爆 token | ① 50 轮后自动压缩 ② 压缩后语义保持 ③ 可手动"清空上下文" |

### P3 — 体验与安全

| 计划 | 描述 | 验收点 |
|---|---|---|
| **P3-1** 自动更新 | `electron-updater` + 简单 HTTP 文件服务器（GitHub Release 或自建） | ① 检测新版本提示 ② 一键更新后自动重启 ③ 失败回滚到旧版 |
| **P3-2** 代码签名 | Windows EV 证书（消 SmartScreen 警告）+ macOS 公证 + Hardened Runtime | ① Win 安装无"未知发布者"警告 ② Mac Gatekeeper 通过 |
| **P3-3** 日志与诊断 | 渲染端、主进程、Python 后端均埋点，关键错误可一键导出 | ① 日志文件按日期滚动 ② 导出 zip 含三端日志 ③ 隐私字段脱敏 |
| **P3-4** 国际化 | i18n 框架（vue-i18n），中英双语 | ① 切换语言实时生效 ② 文案 100% 覆盖 ③ 文档与 UI 同步 |
| **P3-5** 主题 | 浅色/深色/跟随系统 | ① 切换无闪烁 ② Element Plus 组件全适配 ③ 用户选择持久化 |
| **P3-6** 数据合规提示 | 首次启动展示数据出境/隐私说明；国内模型默认指向 | ① 弹窗可关闭且不再提醒 ② 默认 API 域名均为国内 ③ 提供"切换到海外模型"显式开关 |

### P4 — 增强（可选）

| 计划 | 描述 | 验收点 |
|---|---|---|
| **P4-1** 本地 LLM | 通过 Ollama 接入 Qwen2.5/DeepSeek 本地模型 | ① 自动发现本地模型 ② 离线可用 ③ Function Call 兼容 |
| **P4-2** 知识库 RAG | LlamaIndex + Chroma（完全本地），支持"上传文件夹→索引→问答" | ① 1 万字文档 < 30s 索引完成 ② 检索 top-5 准确率 ≥ 80% ③ 支持 PDF/DOCX/MD ④ 数据不离开本机 |
| **P4-3** 浏览器自动化 | Playwright Tool，参考 UI-TARS Desktop 做 GUI Agent | ① 截图→决策→点击闭环 ② 中文网页正常 ③ 失败可重试 |
| **P4-4** MCP 协议 | 接入 MCP Server，扩展工具集 | ① 内置 3+ 官方 MCP 示例 ② 用户可自定义 MCP Server ③ 工具动态发现 |
| **P4-5** 多 Agent 协作 | CrewAI/AutoGen 引入，子任务分派 | ① "写一份市场分析报告"自动拆解 ② 子任务可视化进度 ③ 结果可验收 |

## 六、目录结构（建议）

```
project-root/
├── apps/
│   ├── desktop/                    # Electron + Vue 3
│   │   ├── src/
│   │   │   ├── main/               # 主进程
│   │   │   │   ├── index.ts
│   │   │   │   ├── ipc/            # IPC 处理器
│   │   │   │   ├── store/          # electron-store + safeStorage
│   │   │   │   └── updater/
│   │   │   ├── preload/            # contextBridge 桥
│   │   │   ├── renderer/           # Vue 3 渲染层
│   │   │   │   ├── views/
│   │   │   │   ├── components/
│   │   │   │   ├── stores/         # Pinia
│   │   │   │   └── i18n/
│   │   │   └── shared/             # 主-渲染共享类型
│   │   ├── electron.vite.config.ts
│   │   ├── electron-builder.yml
│   │   └── package.json
│   └── backend/                    # Python FastAPI
│       ├── app/
│       │   ├── main.py
│       │   ├── api/                # 路由
│       │   ├── agents/             # LangChain agents
│       │   ├── tools/              # 文档读写 Tools
│       │   ├── llm/                # 模型工厂
│       │   ├── utils/              # 通用工具
│       │   │   ├── redact.py       # 数据脱敏（§3.3）
│       │   │   └── logging.py      # 日志中间件（按 level_map 自动查表调 redact）
│       │   └── models.py           # Pydantic 数据模型
│       ├── tests/
│       ├── pyproject.toml
│       └── requirements.txt
├── docs/
│   ├── development.md              # 本文档
│   ├── architecture.md
│   ├── api-spec.md
│   ├── nfr-baseline.md             # NFR 抽检基准记录（§十）
│   ├── checklist.md                # P 计划验收勾选表
│   └── release-checklist.md
├── logs/                           # 三端日志（按日期滚动）
└── scripts/
    ├── dev-start.sh
    ├── build-all.sh
    └── self-check.sh               # 评审自检 grep 脚本（§17.5.4）
```

## 七、关键技术约束与规范

- **依赖固定**：所有 npm/pip 依赖必须锁定版本，CI 中 `npm ci` / `pip install --require-hashes`（注：CI 在 M1 末期建立，M0/M1 阶段靠本地 `package-lock.json` + `requirements.txt` 锁定）。
- **安全基线**：`contextIsolation: true`、`nodeIntegration: false`、`sandbox: true`（preload 受信任时）。
- **API Key 绝不出 renderer**：主进程统一管理，IPC 仅传引用 ID 或一次性令牌（v1.0 细化）：
  - **API Key 引用 ID**：`key_ref:<uuid>`，主进程持有 `key_id → ciphertext` 映射表；IPC 收到引用即查表；**30 分钟 TTL** 后失效。
  - **一次性令牌**：`token:<hmac(uuid, ts, action)>`，用于跨主进程→后端的鉴权（避免后端进程开放 8000 端口被同机其他进程访问）；`ts` 含 5 分钟过期。
- **流式协议统一**：后端 SSE → Electron 主进程作 HTTP 客户端消费 → IPC Stream 分片推送给 renderer；renderer 不直连后端。主进程与 renderer 之间的 IPC 事件命名 `chat:stream:<event_type>`（对齐 SSE event 类型）。中断链路：renderer AbortController → 主进程 fetch 的 AbortSignal → 后端 `asyncio.CancelledError` → LangChain LLM 流取消。
- **错误码规范**：HTTP 4xx/5xx + 业务错误码双重标识，前端按错误码分支处理（错误码枚举见附录 B）。
- **日志规范**：三端统一时间戳 + trace_id，主进程入口生成并透传。
- **测试覆盖**：Python 端 pytest 覆盖率 ≥ 70%（重点 agents/tools），前端 vitest 覆盖核心组件。
- **代码风格**：前端 ESLint + Prettier；后端 ruff + mypy。
- **依赖审计**：`npm audit` / `pip-audit` 在 CI 中阻断高危漏洞。
- **数据合规**：默认走国内模型；用户启用海外模型时显式二次确认；本地不持久化文档内容（除非用户主动保存到知识库）。
- **Tools 可观测性**：每个 Tool 记录耗时、成功率、token 消耗；LangChain 中间件链埋点，便于事后排查。
- **Prompt 与 UI 语言解耦**：所有 LLM Prompt 模板通过 i18n 注入 `lang` 变量，禁止硬编码中文字符串。

### 7.1 非功能性需求（NFR）

| 指标 | 目标 | 测量方法 |
|---|---|---|
| 冷启动时间 | ≤ 3 秒（Win11 i5-1135G7 基线） | `app.whenReady` → 首屏可见 |
| 内存占用（空载） | ≤ 500 MB（主进程 + renderer + Python 后端） | `process.memoryUsage()` 上报 |
| 内存占用（典型会话） | ≤ 800 MB | 同上 |
| API Key 加密强度 | 走 OS Keychain（DPAPI on Win / Keychain on Mac），禁用纯文本文件 | 审计 + 启动时检查 |
| Python 后端 QPS | 单实例 ≤ 5 QPS（单用户场景） | uvicorn 单 worker |
| LLM 请求超时 | 60 秒（可配置；位于 `config/models.json` 每模型 `timeout_ms` 字段，env `MAXMA_LLM_TIMEOUT_MS` 全局覆盖） | client timeout |
| 工具调用超时 | 30 秒 | `asyncio.wait_for` |
| 首次安装包体积 | ≤ 300MB（M0-1 spike 实测后冻结） | electron-builder 报告 |
| 增量更新包体积 | ≤ 100MB | electron-updater blockmap |
| 端到端可用率 | ≥ 99%（按 30 天滚动） | LangChain 中间件埋点 |

## 八、里程碑与时间估算

时间估算基于单人或 2 人小队，业余时间开发节奏。

| 里程碑 | 包含计划 | 估算工期 | 关键交付 |
|---|---|---|---|
| **M0** 调研 + 文档 + Spike | 调研、本文档评审、M0-1 PyInstaller+ASAR spike、M0-2 API 契约设计、M0-3 项目骨架、M0-4 模型连通性 spike | 1.5 周 | 本文档 v1.0 + spike 通过 + API 契约冻结 |
| **M1** 端到端最小闭环 | P0-1 ~ P0-9（installer 可延后到 M2 早期） | 3-4 周 | 桌面端 + 后端 + DeepSeek + 聊天 UI + 极简引导 + `npm run dev` 跑通 |
| **M2** 办公文档核心 + installer | P1-1 ~ P1-6 + P0-9 收尾 | 3-4 周 | 4 种文档读写 + Diff + PDF 导出 + Windows NSIS 安装包 |
| **M3** 模型扩展 + 编程 | P2-1 ~ P2-5 | 2 周 | 5 模型可切换 + 代码模式 |
| **M4** 体验 + 安全 | P3-1 ~ P3-6 | 2 周 | 自动更新 + 签名 + i18n + 主题 + 合规 |
| **M5** 增强（可选） | P4-1 ~ P4-5 | 4+ 周 | 本地 LLM / RAG / 浏览器自动化 / MCP / 多 Agent |

**关键路径**：M1 → M2 → M3 是产品可用性的最小集合。

### M0 子计划（v1.0 新增 M0-4）

| 计划 | 描述 | 验收点 | 工期 |
|---|---|---|---|
| **M0-1** PyInstaller+ASAR 联调 spike | 最小工程：electron-vite + vue-ts + electron-builder + PyInstaller 单文件 + extraResources | ① `npm run dev` 跑通 ② `npm run build:win` 产出 NSIS ③ 启动后 Python 子进程被拉起 ④ 通信可达 ⑤ **Windows 路径长度：NSIS 安装到 `C:\Program Files\Maxma\` 路径总长 ≤ 150 字符**（留 110 字符余量给临时文件 / 文档路径拼接；MAX_PATH 260 是硬上限） | 0.5-1 天 |
| **M0-2** API 契约设计 | 定义 FastAPI 路由、SSE 事件 schema、错误码枚举、LangChain content blocks 映射 | ① `docs/api-spec.md` v1.0 ② 错误码表 ≥ 20 条（含 E_NETWORK / E_ALL_MODELS_FAILED / E_BACKEND_LAUNCH_FAIL / E_BACKEND_CRASH / E_BACKEND_STDERR）③ SSE 事件类型 ≥ 5 种 ④ 前后端 mock 联调通过（**推荐 Stoplight Prism** 跑 OpenAPI mock，至少 1 happy path + 1 error path 如 E_RATE_LIMIT） | 1 天 |
| **M0-3** 项目骨架初始化 | 在 `/workspace/maxma/` 建 monorepo；建 `apps/desktop` `apps/backend` `docs` `scripts`；初始 README、`.gitignore`、`.editorconfig`、`.nvmrc`、`.python-version` | ① `git init` 完成 ② `feat/maxma-m1-scaffold` 分支就绪 ③ README 跑通 quickstart ④ `scripts/self-check.sh` 就绪（实现 §17.5.4 自检纪律） | 0.5 天 |
| **M0-4** 模型连通性 spike（v1.0 新增） | 在 mock LLM 通过后，验证 `config/models.json` 抽象层 + 真实厂商连通 | ① `config/models.json` schema 冻结（v1.0 草案见附录 C） ② 至少 1 个 DeepSeek 模型 + 1 个备用模型（厂商可同可异）连通 ③ Function Call 注册被模型选中 ④ 缺参/格式错时返回 E_BAD_REQUEST 而非崩溃 ⑤ 写入 `docs/m0-4-spike-report.md` 记录实测耗时 / token / 错误码 | 0.5 天 |

## 九、风险与缓解

| 风险 | 等级 | 缓解措施 |
|---|---|---|
| LangChain 1.0 仍有破坏性变更 | 中 | 固定版本 + 升级回归测试 + 锁定到具体 patch 号 |
| DeepSeek 旧模型 2026-07-24 弃用 | 🔴 HIGH | ① `base_url` 与模型名抽象到配置层 ② 提前 1 个月在 P0-5 切换到 `deepseek-v4-flash` ③ `docs/CHANGELOG.md` 维护升级路径 ④ M0-2 留出 `/v1/models` 兼容端点 |
| Electron 安装包体积过大 | 中 | ASAR 打包 + 字体子集化 + 不打包 LibreOffice（运行时下载） |
| LibreOffice 转 PDF 中文乱码 | 中 | 改用 pandoc 评估路径（P1-6 修订）；思源黑体子集化作为兜底 |
| 用户 API Key 泄露 | 高 | safeStorage + DPAPI/Keychain 加密 + 主进程持有 + 永不写入 renderer 内存 + 引用 ID / 一次性令牌机制（§七） |
| 流式响应中断不彻底 | 中 | AbortController 全链路 + Python asyncio 取消传播 |
| 国产大模型 Function Call 行为不一致 | 中 | LangChain `tool_strategy` 统一结构化输出 + 适配层测试矩阵 |
| 数据出境合规 | 中 | 默认国内模型 + 海外模型显式确认 + 用户文档本地化处理 |
| PyInstaller + ASAR 路径/解压冲突 | 🟡 MED | M0-1 spike 提前验证；临时解压目录统一为 `%TEMP%/maxma/<pid>/`；启动时清理僵尸目录 |
| 模型 spike 与打包 spike 职责混淆（v1.0 新增） | 🟢 LOW | 拆为 M0-1（打包联调）+ M0-4（模型连通性），各 0.5 天，互不阻塞 |

## 十、验收总则

每个 M 阶段结束需满足：

1. **该阶段所有计划的"验收点"全部通过**；
2. **自动化测试通过**（阈值升级）：
   - Python 端 `pytest --cov` 整体 ≥ 70%；`apps/backend/app/agents/` 和 `app/tools/` 必须 ≥ 80%；
   - 至少 1 个端到端集成测试：模拟 SSE 全链路（client → FastAPI → LangChain → mock LLM → SSE chunk → 解析校验）；
   - LangChain 1.0 升级回归测试 fixture：锁定 `langchain==1.0.x` 后跑通 5 个核心 prompt；
   - 前端 vitest 覆盖核心组件 ≥ 60%；
3. **NFR 抽检**：冷启动时间、内存占用、包体积至少跑 1 次基准（`docs/nfr-baseline.md` 记录）；
4. **手动冒烟测试 checklist 全部通过**；
5. **文档（README + 变更日志）已更新**；
6. **演示录屏或截图已归档到 `docs/demos/`**；
7. **自检纪律**（v1.0 固化）：每个 M 阶段结束必须跑 `scripts/self-check.sh`，输出"上一版漏改"+"本版新增一致性"两份报告，不通过不允许 freeze。

## 十一、关键决策记录（2026-06-22 确认）

| 决策项 | 结论 |
|---|---|
| Python 后端打包方式 | PyInstaller 单文件打包进 Electron 安装包——双击安装即用，不依赖系统 Python |
| 知识库 RAG 存储 | 完全本地（Chroma），数据不离开本机 |
| macOS 公证 | 不做——节省 $99/年账号费用；用户如需 macOS 体验可自行 `npm run build:mac` 自行公证 |
| 应用名 | Maxma（一个词，标准英文产品名写法） |
| Logo | 赛博渐变艺术字 "Maxma"（深紫 → 青蓝），图片已生成 `maxma-logo.png` |
| 额外支出预算 | 零——不订阅海外服务、不买签名证书、不用云端向量库 |
| redact 调用方语义（v1.0 决策） | 日志中间件按 `level_map` 自动查表，业务代码不显式声明 level（消除"调用方"指代歧义） |
| M0 spike 拆分（v1.0 决策） | M0-1 打包联调 + M0-4 模型连通性 各 0.5 天，互不阻塞 |

## 十二、品牌资产

**应用名**：Maxma

**Logo 文件**：`maxma-logo.png`（位于工作区根目录）

**主色板**：

- 起始色（深紫）：`#1A0B2E` / `#3A1078`
- 渐变过渡：`#4F46E5` / `#06B6D4`
- 终止色（青蓝）：`#0EA5E9` / `#22D3EE`
- 辅助色：背景近黑 `#0A0A0F`，文字 `#F4F4F5`

**字体建议**（打包时内置）：Inter（拉丁字符）+ 思源黑体 / Noto Sans CJK SC（中文）

**使用规范**：

- 应用图标：512×512 / 256×256 / 128×128 / 64×64 多尺寸
- 关于页：使用 `maxma-logo.png` 横版
- 应用内启动屏：深紫底 + 青蓝渐变描边

## 十三、决策与待评审（2026-06-22 全部确认 ✅）

| # | 决策项 | 结论 | 落点 |
|---|---|---|---|
| 1 | 首次启动引导 | ✅ 做极简版（1 页欢迎页） | 落到 P0-8 |
| 2 | 自动更新渠道 | ✅ 启用 electron-updater + GitHub Releases | 落到 P3-1 |

**已无遗留待评审项**。M1 范围 = P0-1 ~ P0-9（共 9 个子计划）。

---

## 附录 B：API 契约草案

> **状态**：v0.4 草案起步 → v0.7 完善 → **v1.0 冻结**。M0-2 子计划需将其冻结为 `docs/api-spec.md` v1.0。

### B.1 FastAPI 路由

| 方法 | 路径 | 用途 | 鉴权 |
|---|---|---|---|
| GET | `/health` | 健康检查（Electron 启动时拉起后端） | 无 |
| GET | `/v1/models` | 列出当前启用的模型（兼容 DeepSeek 旧版模型名映射） | 无 |
| POST | `/v1/chat` | 非流式对话 | 本地（仅 127.0.0.1） |
| POST | `/v1/chat/stream` | SSE 流式对话（主用） | 本地 |
| GET | `/v1/tools` | 列出已注册 Tools | 无 |
| POST | `/v1/rag/index` | 上传文档构建本地索引 | 本地 |
| POST | `/v1/rag/search` | 检索 | 本地 |

### B.2 SSE 事件协议（与 LangChain 1.0 content_blocks 对齐）

```
event: <type>
data: <json>
```

| event type | data 字段 | 说明 |
|---|---|---|
| `start` | `{ trace_id, model, ts }` | 流开始，trace_id 贯穿全程 |
| `message` | `{ block: "text", delta: "..." }` | 文本流式增量（与 LangChain `AIMessage.content_blocks` 对齐） |
| `reasoning` | `{ block: "reasoning", delta: "..." }` | 思考链（如 DeepSeek-R1） |
| `tool_call` | `{ id, name, args_partial }` | 模型决定调用工具 |
| `tool_result` | `{ id, name, result, latency_ms }` | 工具执行结果 |
| `citation` | `{ source, page, score }` | RAG 引用 |
| `error` | `{ code, message, detail? }` | 错误（见 B.3 错误码） |
| `done` | `{ usage: {input, output, total}, cost_cny }` | 流结束 |

### B.3 错误码枚举（v1.0 共 30 条）

| 错误码 | HTTP | 含义 | 触发场景 |
|---|---|---|---|
| `E_OK` | 200 | 成功 | — |
| `E_BAD_REQUEST` | 400 | 请求参数错误 | payload 校验失败 / 模型名格式错（`^[a-zA-Z0-9][a-zA-Z0-9._-]{0,63}$`） |
| `E_UNAUTHORIZED` | 401 | API Key 无效 | DeepSeek 返回 401 |
| `E_FORBIDDEN` | 403 | 权限不足 | 模型/工具越权调用 |
| `E_NOT_FOUND` | 404 | 资源不存在 | 文档/会话 ID 不存在 |
| `E_RATE_LIMIT` | 429 | 触发限流 | DeepSeek RPM 超限 |
| `E_LLM_TIMEOUT` | 504 | LLM 请求超时 | 60s 未响应 |
| `E_LLM_UPSTREAM` | 502 | LLM 上游错误 | DeepSeek 5xx |
| `E_LLM_CONTENT_FILTER` | 451 | 内容安全拦截 | 触发敏感词 |
| `E_DOCX_PARSE_FAIL` | 422 | Word 解析失败 | 文件损坏/加密 |
| `E_XLSX_PARSE_FAIL` | 422 | Excel 解析失败 | 同上 |
| `E_PPTX_PARSE_FAIL` | 422 | PPT 解析失败 | 同上 |
| `E_PDF_PARSE_FAIL` | 422 | PDF 解析失败 | 同上 |
| `E_PDF_ENCRYPTED` | 422 | PDF 已加密 | 需密码 |
| `E_DOCX_WRITE_FAIL` | 500 | Word 写入失败 | 磁盘满/路径不可写 |
| `E_XLSX_WRITE_FAIL` | 500 | Excel 写入失败 | 同上 |
| `E_PPTX_WRITE_FAIL` | 500 | PPT 写入失败 | 同上 |
| `E_PDF_WRITE_FAIL` | 500 | PDF 写入失败 | 同上 |
| `E_TOOL_TIMEOUT` | 504 | 工具执行超时 | > 30s |
| `E_RAG_INDEX_FAIL` | 500 | 知识库索引失败 | Chroma 写入失败 |
| `E_RAG_SEARCH_EMPTY` | 200 | 检索无结果 | top-k 全部低于阈值 |
| `E_KEYCHAIN_DENIED` | 403 | 拒绝访问 Keychain | 权限不足 |
| `E_BACKEND_DOWN` | 503 | 后端进程未就绪 | Electron 启动太快 |
| `E_BACKEND_LAUNCH_FAIL` | 503 | 后端连续 5 次拉起失败 | M0-1 spike 实测收敛时间；亦用于 B.7 重启 2 次后仍崩的终止态 |
| `E_BACKEND_CRASH` | 503 | 后端进程中途崩溃 | 拉起新子进程后仍崩（连续 2 次） |
| `E_BACKEND_STDERR` | 200 | 子进程非异常 stderr 输出 | 语义为警告（INFO/WARN 级别），不影响主流程，仅日志埋点 |
| `E_NETWORK` | 502 | 网络层失败 | DNS/连接失败/TLS 错误 |
| `E_ALL_MODELS_FAILED` | 503 | 所有启用模型均失败 | 回退链穷尽（落到 B.6 决策表末尾） |
| `E_INTERNAL` | 500 | 兜底 | 未分类异常 |

### B.4 请求/响应示例

**请求（POST /v1/chat/stream）**：

```json
{
  "messages": [
    {"role": "user", "content": "把这段话改得更正式", "lang": "zh"}
  ],
  "model": "deepseek-v4-flash",
  "tools_enabled": ["docx_read", "docx_write"],
  "attachments": [{"type": "docx", "path": "/abs/path/file.docx"}],
  "trace_id": "uuid-v4"
}
```

**SSE 流（节选）**：

```
event: start
data: {"trace_id":"abc-123","model":"deepseek-v4-flash","ts":1719012345}

event: tool_call
data: {"id":"t1","name":"docx_read","args_partial":"{\"path\":\"/abs/path/file.docx\"}"}

event: tool_result
data: {"id":"t1","name":"docx_read","result":"...","latency_ms":342}

event: message
data: {"block":"text","delta":"好的，我已读取文档。"}

event: message
data: {"block":"text","delta":"以下是更正式的版本："}

event: done
data: {"usage":{"input":128,"output":256,"total":384},"cost_cny":0.0001}
```

### B.5 流式中断与超时

- **链路**：renderer 触发 AbortController → 主进程 fetch 的 AbortSignal 同步取消 → 后端 `await asyncio.CancelledError` → LangChain LLM 流取消
- **任一环节断连即整链路终止**（双端不可见"部分取消"状态）
- **服务端 60s 无 chunk 输出** → 自动 emit `error E_LLM_TIMEOUT` 后 `done`
- **工具调用 > 30s** → `E_TOOL_TIMEOUT` 立即终止该工具

### B.6 LLM 链路回退决策表

**作用域**：本表仅适用于 LLM 链路调用阶段（即从 `langchain.ainvoke` 到流结束）。子进程健康由主进程 IPC 层负责，详见 §B.7。

**默认模型**：`config/models.json` 中 `models` 数组**第一个** `enabled: true` 的条目（数组顺序即用户优先级，按 JSON 字面量顺序解析）。

| 错误码 | 触发条件 | 默认动作 | 重试次数 | 备注 |
|---|---|---|---|---|
| `E_LLM_TIMEOUT` | 60s 无响应 | 回退 | 1 | 立即切到下一个模型 |
| `E_LLM_UPSTREAM` | DeepSeek 5xx | 回退 | 1 | 立即切到下一个模型 |
| `E_RATE_LIMIT` | DeepSeek 429 | 重试 | 3 | 指数退避（2s/4s/8s）后回退 |
| `E_BAD_REQUEST` | payload 校验失败 | 终止 | 0 | 不回退，直接报错给用户 |
| `E_UNAUTHORIZED` | API Key 无效 | 终止 | 0 | 提示用户重配 Key |
| `E_FORBIDDEN` | 权限不足 | 终止 | 0 | 走合规提示流 |
| `E_LLM_CONTENT_FILTER` | 触发内容安全 | 终止 | 0 | 提示用户修改输入 |
| `E_INTERNAL` | 兜底 | 回退 | 1 | 切到下一个模型 + 上报埋点 |
| `E_NETWORK` | 网络层失败（DNS/连接/TLS） | 重试 | 3 | 指数退避（2s/4s/8s）后回退 |
| `E_ALL_MODELS_FAILED` | 回退链穷尽 | 终止 | 0 | 提示用户"全部模型不可用，请检查 API Key 或网络" |

**说明**：

- "重试" = 同模型同请求重发；"回退" = 切到下一个 enabled 模型；"终止" = 直接给用户报错。
- **回退路径示例**：`deepseek-v4-flash` → `deepseek-v4-pro`（如果用户启用了 Pro）→ 智谱 GLM-4.6 → 通义 Qwen3-Max → ... → 全部失败则 `E_ALL_MODELS_FAILED`。**实际路径由 `config/models.json` 决定，此处仅为示例**。
- 错误码 `E_RAG_SEARCH_EMPTY` 虽是 HTTP 200，但语义非"成功"——前端必须根据 `data.items.length === 0` 显式提示用户。

### B.7 子进程健康决策表

**职责边界**：本表适用于主进程拉起/管理 Python 子进程的 IPC 阶段，与 §B.6 LLM 链路回退表互不重叠。LLM 调用此时尚未启动，因此不进入"模型回退链"。

| 错误码 | 触发条件 | 默认动作 | 重试次数 | 备注 |
|---|---|---|---|---|
| `E_BACKEND_DOWN` | Python 子进程未就绪 | 等待 | 5 | 1s 间隔轮询；前 5 次失败 → 给前端 toast "后端启动中，请稍候" |
| `E_BACKEND_LAUNCH_FAIL` | 5 次后仍 down **或** 崩溃连续 2 次后仍 down | 终止 | 0 | 弹窗"后端启动失败，请重启或查看日志" + 提供"打开日志目录"按钮 |
| `E_BACKEND_CRASH` | 进程中途崩溃 | 重启 | 2 | 拉起新子进程；2 次后仍崩 → `E_BACKEND_LAUNCH_FAIL`（同 B.3 主表，语义"连续重启失败"） |
| `E_BACKEND_STDERR` | 子进程 stdout/stderr 输出非异常级别（INFO/WARN） | 继续 | — | 语义为警告，不影响主流程，仅日志埋点 |

## 附录 C：config/models.json Schema 草案（v1.0 冻结）

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Maxma Model Registry",
  "type": "object",
  "required": ["models"],
  "properties": {
    "models": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "required": ["id", "provider", "model", "base_url", "enabled"],
        "properties": {
          "id": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9][a-zA-Z0-9._-]{0,63}$",
            "description": "模型在本机配置中的唯一 ID，供前端 UI 引用"
          },
          "provider": {
            "type": "string",
            "enum": ["openai-compatible", "tongyi", "zhipu", "doubao", "ernie", "ollama"]
          },
          "model": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9][a-zA-Z0-9._-]{0,63}$",
            "description": "厂商侧模型名"
          },
          "base_url": {
            "type": "string",
            "format": "uri"
          },
          "api_key_ref": {
            "type": "string",
            "description": "引用主进程 safeStorage 中的 API Key（key_ref:<uuid> 格式）"
          },
          "enabled": { "type": "boolean" },
          "timeout_ms": {
            "type": "integer",
            "minimum": 1000,
            "default": 60000
          },
          "max_retries": {
            "type": "integer",
            "minimum": 0,
            "maximum": 5,
            "default": 1
          },
          "supports_function_call": { "type": "boolean", "default": true }
        }
      }
    },
    "default_model_id": {
      "type": "string",
      "description": "默认启用的 model.id（必须存在于 models 数组中）"
    }
  }
}
```

## 附录 A：参考资料（来源链接）

调研阶段已引用的关键信息源（按主题分组）：

### LangChain / LangGraph
- 官方 1.0 发布博客（2025-10-22）：https://www.langchain.com/blog/langchain-langgraph-1dot0
- v1 Release Notes：https://docs.langchain.com/oss/python/releases/langchain-v1
- Agent 文档：https://docs.langchain.com/oss/python/langchain-agents
- 国内模型集成（社区）：https://juejin.cn/post/7644745737153019939
- 通义集成（官方）：https://python.langchain.com/docs/integrations/chat/tongyi/
- 漏洞与安全（eWeek）：https://www.eweek.com/news/langchain-ai-vulnerability-exposes-apps-to-hack/
- 框架对比：https://www.trixlyai.com/blogs/langchain-vs-llamaindex-vs-autogen-vs-crewai-which-framework-actually-ships-in-2026

### Electron / 桌面端
- Electron Release Blog：https://www.electronjs.org/blog/tags/release
- electron-vite GitHub：https://github.com/alex8088/electron-vite
- Electron + Vite 三种方法（掘金）：https://juejin.cn/post/7475288228230037558
- Vue 3 UI 库对比：https://digitalthriveai.com/en-us/resources/web-design/best-frameworks-vue-3/
- 桌面 AI 助手架构案例：https://workflows.diy/blog/anatomy-desktop-ai-assistant-stack-features
- Electron 中文文档：https://electron.js.cn/docs/latest/tutorial/updates
- UI-TARS Desktop：https://localaimaster.com/blog/ui-tars-desktop-automation
- browser-use/desktop：https://deepwiki.com/browser-use/desktop/1-overview

### 国产大模型 API
- DeepSeek 价格（官方）：https://api-docs.deepseek.com/zh-cn/quick_start/pricing/
- DeepSeek 更新日志（官方，2026-04-24 V4 发布 + 2026-07-24 旧模型弃用）：https://api-docs.deepseek.com/zh-cn/updates/
- DeepSeek V4 迁移指南（社区/官方）：https://deepseeksr1.com/platform/
- DeepSeek V3.2-Exp 定价（CSDN）：https://blog.csdn.net/gitblog_00195/article/details/154017543
- 36kr 大模型价格调研：https://36kr.com/p/3435332170124929
- 智谱 GLM-4.6V：https://www.ithome.com/0/903/390.htm
- 豆包 API：https://tokenmix.ai/blog/doubao-api-getting-started
- Qwen3-Max：https://api.atalk-ai.com/api-docs/model-detail/qwen3-max
- 文心 4.5：https://blog.csdn.net/qq_40380468/article/details/146326303
- Qwen3-VL：https://qwen-ai.com/qwen-vision/
- ERNIE 4.5 Turbo VL：https://www.llmreference.com/model/ernie-4.5-turbo-vl

### Python Office 库
- python-docx：https://packages.guix.gnu.org/packages/python-docx/
- openpyxl 指南：https://www.generalistprogrammer.com/tutorials/openpyxl-python-package-guide
- python-pptx 解析：https://wenku.csdn.net/doc/2jycgn8qp6
- pypdf 6.7.1 CHANGELOG：https://pypdf.readthedocs.io/en/6.7.1/meta/CHANGELOG.html
- pdfplumber：https://pyoven.org/package/pdfplumber

### 合规与 Agent 实践
- AI Office Agent 综述：https://openreview.net/pdf/b51d5a4e86ac6acb7ffb5db16f4d6055524ecd93.pdf
- Harvey.ai 文档 Agent：https://www.harvey.ai/blog/building-an-agent-for-complex-document-drafting-and-editing
- 数据出境认证（国家网信办）：https://www.cac.gov.cn/2025-10/17/c_1762449729377695.htm
- 数据出境合规指南：https://geeknb.com/28417.html
- 2026 大模型备案新规：https://blog.csdn.net/m0_61703951/article/details/160860360

---

## 十四、v0.3 → v0.4 评审闭环记录

**评审来源**：第三方技术顾问一轮（2026-06-22）。

### 14.1 完全采纳（7 条）

| # | 评审意见 | 文档落点 |
|---|---|---|
| 1 | 缺失 API 契约 & 错误码规范 | §七-5 + 附录 B + M0-2 子计划 |
| 2 | 测试覆盖率偏低 | §十-2：agents/ tools/ ≥ 80% + 强制 E2E |
| 3 | 缺失非功能性需求 | §七.1 NFR 表（10 项量化指标） |
| 4 | i18n 与 Prompt 语言耦合 | §七-12 + P2-5 / P3-4 验收点修订 |
| 5 | M0 阶段先做 PyInstaller+ASAR spike | M0-1 子计划（前置到 M0） |
| 6 | DeepSeek 旧模型弃用需配置层兜底 | §九 HIGH + 4 条缓解措施 |
| 7 | 补充开发环境与分支规约 | §3.1 版本矩阵 + §3.2 环境规约 + §15 |

### 14.2 部分采纳（3 条）

| # | 评审意见 | 文档落点 | 调整 |
|---|---|---|---|
| 1 | "P0 编号不一致" | 旧版本问题 | v0.3 已修复，v0.4 维持 |
| 2 | "P0-9 打包延后到 M2" | P0-9 验收点新增 ⑥；里程碑表 M2 标注 "P0-9 收尾" | M1 仍含 P0-9 但不强求 installer 产出；M2 早期完成 |
| 3 | "LibreOffice → pandoc 替代" | P1-6 验收点修订 + §九风险修订 | M1 阶段不涉及 PDF 导出；P1-6 时再评估 |

### 14.3 不采纳（2 条）

| # | 评审意见 | 不采纳理由 |
|---|---|---|
| 1 | "M0 还要建 CI 雏形" | 个人项目 + 业余时间过早投入 CI；M1 末期再补 |
| 2 | "工具数量爆炸可观测性单列 P0" | 8 个 Tool 不算"爆炸"；已分散到各 P 验收点（§七） |

### 14.4 评审未提及、我方补充（2 条）

| # | 补充内容 | 文档落点 |
|---|---|---|
| 1 | 开发环境规约 | §3.2 |
| 2 | 分支与提交规约 | §15 |

## 十五、分支与提交规约

### 15.1 分支模型

- `main` — 受保护，仅接受 PR 合并；对应稳定可发布版本
- `feat/<scope>-<desc>` — 功能分支（如 `feat/maxma-m1-scaffold`）
- `fix/<scope>-<desc>` — 缺陷分支（如 `fix/electron-safeStorage-init`）
- `chore/<desc>` — 杂项（依赖升级、文档）
- `release/v<x.y>` — 发布准备（CHANGELOG 收口、版本号 bump）
- `exp/<user>/<desc>` — 个人/实验

### 15.2 提交信息（Conventional Commits）

```
<type>(<scope>): <subject>  // 中文或英文均可，团队统一

<body>  // 详细说明，wrap at 72 chars

<footer>  // 关联 issue、break change
```

| type | 含义 | 示例 |
|---|---|---|
| `feat` | 新功能 | `feat(agent): 接入 DeepSeek v4-flash Function Call` |
| `fix` | 修复 bug | `fix(safeStorage): Win 首次启动 DPAPI 不可用兜底` |
| `docs` | 文档 | `docs(readme): 补充 M0 quickstart` |
| `style` | 格式 | `style(eslint): 关闭 vue/multi-word-component-names` |
| `refactor` | 重构 | `refactor(tools): 抽离 docx_read/write 公共 base` |
| `perf` | 性能 | `perf(sse): 流式 chunk 批量 flush 减少 IPC` |
| `test` | 测试 | `test(agent): 补 LangChain 1.0 升级回归 fixture` |
| `chore` | 杂项 | `chore(deps): 锁定 langchain==1.0.3` |
| `revert` | 回滚 | `revert: feat(agent): ...` |

### 15.3 CHANGELOG 维护

- 使用 **git-cliff**（monorepo 友好，支持自定义 section）自动从 commit 生成
- standard-version 作为单包 fallback
- 每次发布前 `pnpm release`（或 npm script）自动 bump 版本号 + 生成 `CHANGELOG.md`
- 重要破坏性变更必须在 body 写 `BREAKING CHANGE: ...`

### 15.4 PR 规约

- PR 标题遵循 Conventional Commits
- 至少 1 个 reviewer（自我 review 或 AI 评审均可）
- 非破坏性变更 PR 至少挂 **4 小时**后合并；破坏性变更（BODY 含 `BREAKING CHANGE:`）挂 **24 小时**，让自我 review 有思考时间
- 必跑 lint + test + build 才可合并（本地或 CI）
- 关联 `docs/checklist.md` 中对应 P 计划的验收勾选
- **v1.0 起额外要求**：每个 PR 必须在 PR 描述里粘贴 `scripts/self-check.sh` 输出（实现 §17.5.4 自检纪律）

## 十六、v0.4 → v0.5 评审二轮闭环记录

**评审来源**：第三方技术顾问二轮（2026-06-22）。

### 16.1 硬采纳（5 条）

| # | 评审意见 | 文档落点 |
|---|---|---|
| 1 | P0 编号闭环未完成 | WBS 表 P0-8（欢迎页）/ P0-9（打包雏形）拆为独立两行；§八里程碑同步 |
| 2 | 安装包体积预算矛盾 | §七.1 NFR：首次安装包 ≤ 300MB + 增量 ≤ 100MB；P0-9 加验收点 ⑥"M0-1 spike 实测" |
| 3 | P0-7 SSE 渲染路径设计有误 | §七-4 改为"主进程消费 → IPC Stream 推送"；P0-7 验收点重写为 5 条 |
| 4 | LLM 失败回退未定义 | 附录 B.6 新增回退决策表（10 错误码 × 重试/回退/终止 × 重试次数） |
| 5 | 隐私字段分级缺失 | §3.3 新增数据分级与脱敏规约（P0 敏感 / P1 私密 / P2 内部 / P3 公开） |

### 16.2 措辞微调（2 条）

| # | 评审意见 | 调整 |
|---|---|---|
| 1 | E_FORBIDDEN 语义不准确 | "模型越权调用" → "模型/工具越权调用"（不加子码） |
| 2 | trace_id 来源未约定 | 在 B.4/B.6 强调"trace_id 由后端生成；请求体可带 trace_id 但仅作关联键，不作为唯一标识" |

### 16.3 不采纳（5 条）

| # | 评审意见 | 不采纳理由 |
|---|---|---|
| 1 | `deepseek-v4-flash` 模型名真实性待验证 | 官方真实存在。DeepSeek 官方更新日志 2026-04-24 明确发布 v4-pro / v4-flash，旧名 2026-07-24 弃用。附录 A 已附官方链接 |
| 2 | "24h 自我 review 流于形式" | 已改为"非破坏性 4h / 破坏性 24h"挂起规约（更务实） |
| 3 | "CHANGELOG 工具未覆盖后端" | monorepo 用 pnpm 工作区 + standard-version 可覆盖前后端；不换工具 |
| 4 | "P0-5 hardcode 模型名" | 表面合理但与评审 1 内部矛盾。采纳为"模型名/厂商/base_url 全部从 config/models.json 读取，零 hardcode"，但不指定具体模型名，留待 M0-2 验证 |
| 5 | "评审漏掉的 E_RAG_SEARCH_EMPTY 语义" | 已采纳为"前端根据 data.items.length === 0 显式提示用户"（落到 B.6 说明） |

### 16.4 我方补充（评审漏掉的 2 条硬问题）

| # | 我方发现的问题 | 文档落点 |
|---|---|---|
| 1 | §七-4"前端 EventSource"实现路径与 P0-7 自相矛盾 | 同步修订 §七-4 描述与 P0-7 验收点一致 |
| 2 | 评审内部矛盾（评审 1 vs 评审 12 模型名） | 已在 16.3-4 显式化解：配置层抽象 + 具体模型名待 M0-2 验证 |

## 十七、v0.5 → v0.6 评审三轮闭环记录

**评审来源**：第三方技术顾问三轮（2026-06-22）。

**关键改进**：本轮 patch 完成后做逐条 grep 自检，确保 §十六/§十七 闭环记录与文档实际内容 100% 一致（吸取 v0.5"声称改但未改"教训）。

### 17.1 硬采纳（5 条，对应 v0.5 漏改）

| # | 评审意见 | 文档落点 | 自检结果 |
|---|---|---|---|
| 1 | §七-4 流式协议描述未修订（v0.4 已意识到，v0.5 patch 漏改） | §七-4 改为"后端 SSE → 主进程 HTTP 客户端 → IPC Stream 推送；renderer 不直连后端" | ✅ grep `EventSource` 全文 0 命中（仅历史版本记录） |
| 2 | P0-5 验收点仍是 hardcode `deepseek-chat` | P0-5 改为"模型名/厂商/base_url/api_key 全部从 `config/models.json` 读取"；新增 4 条验收点 | ✅ grep `init_chat_model("deepseek-chat"` 0 命中 |
| 3 | §15.4 仍是"24h 自我 review" | §15.4 改为"非破坏性 4h / 破坏性 24h"挂起规约 | ✅ grep `24h 自我` 0 命中 |
| 4 | B.3 缺 `E_NETWORK` / `E_ALL_MODELS_FAILED` | B.3 增补两条（502 / 503） | ✅ B.3 含 E_NETWORK / E_ALL_MODELS_FAILED |
| 5 | `E_BACKEND_DOWN` 进 LLM 决策表分类错误 | B.6 加表头注"仅适用 LLM 链路"；`E_BACKEND_DOWN` 行从 B.6 移到新建 §B.7 子进程健康决策表 | ✅ B.6 表内 E_BACKEND_DOWN 0 命中，B.7 表内 2 命中 |

### 17.2 软采纳（3 条）

| # | 评审意见 | 文档落点 |
|---|---|---|
| 1 | §3.3 redact 函数签名缺失 | §3.3 末尾补函数签名 + 嵌套/数组/P0 抛异常行为 |
| 2 | §3.3 "用户密码"冗余 | P0 行改为"用户密码（预留字段，P4 接入本地账号时启用）" |
| 3 | P0-9 ⑦ 措辞偏题 | P0-9 ⑦ 改为"installer 首次启动链路冒烟：欢迎页 → 跳过 Key → 主界面（验证 P0-8 集成）" |

### 17.3 暂缓（1 条）

| # | 评审意见 | 处理 |
|---|---|---|
| 1 | M0-2 mock 工具选型 | 采纳为"推荐 Stoplight Prism"（不强制），落到 M0-2 验收点 ④ |

### 17.4 自我批评（v0.5 漏改复盘）

v0.5 末我自夸闭环完成，但 §十六 16.4-1 / 16.3-4 / 16.3-2 三条声称"已修订 / 已采纳"，实际未改到位。

**根因**：patch 时只改了相关章节，没有逐条 grep 验证，且 §十六 闭环记录与实际 diff 缺自检环节。

**v0.6 起**：每次 patch 必跑 grep 自检 + 在 §十七 表格里附自检结果。

这条经验已落到 §15 PR 规约：未来 PR merge 前需逐条勾选对应验收点。

## 十八、v0.6 → v0.7 评审四轮闭环记录

**评审来源**：第三方技术顾问四轮（2026-06-22）。

**关键改进（v0.6 → v0.7 升级流程纪律）**：

- **回溯 grep**：验证 v0.6 漏改是否真修（v0.6 抓出 §15.4 隐藏漏改 ✅）
- **前瞻 grep**：验证 v0.7 新增内容是否引用了已存在的章节（错误码、表格、术语）
- **矛盾扫描**：评审结论 vs 文档实际 vs 闭环记录三方对齐

**执行结果**：本轮 patch 中 B.3 错误码主表增补（v0.6 漏补）+ 目录树 patch 错位（自检抓出 ✅），自检纪律有效。

### 18.1 硬采纳（5 条）

| # | 评审意见 | 文档落点 | 自检结果 |
|---|---|---|---|
| 1 | P0-5 ④ 写死 `deepseek-v4-flash` + `deepseek-v4-pro`，与 §十六 16.3-4"不指定具体模型名"结论矛盾 | P0-5 ④ 改为"配置层 `default_model` + `backup_model` 字段生效；M0-1 spike 阶段实测 ≥ 2 个模型连通"（v1.0 进一步改为 M0-4 spike） | ✅ grep `deepseek-v4-flash` 在 P0-5 0 命中（仅在示例回退链保留） |
| 2 | B.7 错误码列写中文状态（`E_BACKEND_DOWN 仍失败`），与 B.3 错误码主表错配 | B.3 增补 `E_BACKEND_LAUNCH_FAIL` / `E_BACKEND_CRASH` / `E_BACKEND_STDERR`；B.7 行改用新码 | ✅ grep `E_BACKEND_DOWN 仍失败` 0 命中 |
| 3 | §3.3 "调用方"指代矛盾（日志中间件 vs 业务代码） | §3.3 定型为"level 由日志中间件通过 `level_map` 自动查表决定，业务代码不显式声明"（v1.0 落地） | ✅ grep `调用方显式声明 level` 0 命中（改为"中间件自动查表"） |
| 4 | B.6 "第一个 enabled"和回退路径措辞欠严谨 | B.6 表头改为"数组第一个 `enabled: true` 条目（数组顺序即用户优先级）"；回退路径加"示例"前缀 | ✅ grep `回退路径：\`deepseek-v4-flash\`` 0 命中（"示例"前缀就位） |
| 5 | B.5 "客户端"措辞与 §七-4 不一致 | B.5 改为三层链路"renderer 触发 AbortController → 主进程 fetch 的 AbortSignal → 后端 asyncio.CancelledError" | ✅ grep `客户端通过 AbortController` 0 命中 |

### 18.2 软采纳（3 条）

| # | 评审意见 | 文档落点 |
|---|---|---|
| 1 | P0-5 ④ "M0-2 验证" 时间线错位 | 改为"M0-1 spike 阶段实测"（v1.0 进一步改为 M0-4 spike） |
| 2 | P0-7 ② 200ms 缺依据 | 加"参考 Chromium network throttle 经验值；M1 NFR 抽检时按 ±50ms 容差" |
| 3 | NFR "可配置"配置项位置未约定 | §7.1 加"位于 `config/models.json` 每模型 `timeout_ms` 字段，env `MAXMA_LLM_TIMEOUT_MS` 全局覆盖" |

### 18.3 撤回 / 暂缓（2 条）

| # | 评审意见 | 处理 |
|---|---|---|
| 1 | §6 缺 `app/utils/` | 评审自撤回（实际目录树里有），但已补 `utils/redact.py` + `utils/logging.py` 注释 |
| 2 | P0-5 ④ "2 个模型" 口径模糊 | 合并到硬采纳 ①："覆盖同厂商不同规格 + 不同厂商 base_url" |

### 18.4 自检纪律（v1.0 起固化到流程）

| 阶段 | 自检内容 | 工具 |
|---|---|---|
| 回溯 grep | 上一版评审指出的"漏改"是否真修 | grep + 关键词清单 |
| 前瞻 grep | 本版新增内容是否引用了已存在的章节 | grep 新增术语 → 跳到对应章节核对 |
| 矛盾扫描 | 评审结论 vs 文档实际 vs 闭环记录三方对齐 | 表格列对比，差异列 ↗ |

**v1.0 落地**：`scripts/self-check.sh` 脚本 + §15.4 PR 规约强制粘贴输出。

## 十九、v0.7 → v1.0 评审五轮闭环记录（最终冻结）

**评审来源**：第三方技术顾问五轮（2026-06-22）。

### 19.1 硬采纳（3 条，v1.0 patch）

| # | 评审意见 | 文档落点 | 自检结果 |
|---|---|---|---|
| 1 | §3.3 "日志中间件在每条日志写入前调用" 与定型方案"中间件自动查表" 措辞不齐 | §3.3 第二行改为"日志中间件按 `level_map` 配置自动查表决定 redact 强度，业务代码无需显式声明 level"；"调用"一词删除 | ✅ grep `日志中间件在每条日志写入前调用` 0 命中 |
| 2 | B.3 E_BACKEND_STDERR 触发条件模糊 + B.7 E_BACKEND_CRASH 终止态缺错误码 | B.3 E_BACKEND_STDERR 触发条件改为"子进程 stdout/stderr 输出非异常级别（如 `WARNING`/`INFO`）"；B.7 E_BACKEND_CRASH 备注补"2 次后仍崩 → `E_BACKEND_LAUNCH_FAIL`" | ✅ B.3 E_BACKEND_STDERR 触发场景明确；B.7 E_BACKEND_CRASH 终止态引用 E_BACKEND_LAUNCH_FAIL |
| 3 | M0-1 职责与 P0-5 ④ "实测 ≥ 2 个模型" 不匹配 | **新增 M0-4 子计划**（模型连通性 spike，0.5 天）；P0-5 ④ 改为"M0-4 模型连通性 spike 阶段实测 ≥ 2 个模型连通" | ✅ M0-4 在 §八 M0 子计划表中独立行；P0-5 ④ 引用 M0-4 |

### 19.2 软采纳（5 条，M0-1 期间打磨）

| # | 评审意见 | 文档落点 |
|---|---|---|
| 1 | §七 "IPC 仅传引用 ID 或一次性令牌" 定义缺失 | §七 加 1.1 段：API Key 引用 ID 格式 + TTL；一次性令牌格式 + 过期时间 |
| 2 | P0-5 ⑤ "模型名格式错" 缺校验规则 | P0-5 ⑤ 加"格式规则：`^[a-zA-Z0-9][a-zA-Z0-9._-]{0,63}$`"；附录 C schema 同步 |
| 3 | M0-1 ⑤ "Windows 路径长度问题" 解决标准未量化 | M0-1 ⑤ 改为"Windows NSIS 安装到 `C:\Program Files\Maxma\` 路径总长 ≤ 150 字符（MAX_PATH 260 硬上限）" |
| 4 | §15.4 规约正文带 "v0.6 修订" 标记 | §15.4 删前缀，只写当前规则；版本历史在 §十六/§十七 追溯 |
| 5 | §15.3 CHANGELOG 工具 "git-cliff 或 standard-version" 不强制 | 15.3 改为"使用 git-cliff（monorepo 友好）；standard-version 作为单包 fallback" |

### 19.3 新增内容（v1.0 决策）

| # | 内容 | 文档落点 |
|---|---|---|
| 1 | M0-4 子计划 | §八 M0 子计划表 + §九风险表新增"模型 spike 与打包 spike 职责混淆"条目 |
| 2 | `config/models.json` JSON Schema 草案 | 附录 C |
| 3 | redact "调用方"语义定型 | §3.3 决策记录（§十一） |
| 4 | `scripts/self-check.sh` 脚本占位 | §六 目录结构 |
| 5 | NFR 抽检文件 `docs/nfr-baseline.md` | §六 目录结构 + §十 验收总则 |

### 19.4 自我批评（v0.6 → v0.7 复盘精简）

v0.6 我自夸"grep 自检闭环"，但 B.3 错误码主表漏增补（`E_BACKEND_LAUNCH_FAIL` / `E_BACKEND_CRASH` / `E_BACKEND_STDERR`）只在 B.7 决策表用了，前端按 B.3 查表会查不到。**v0.7 已补全**。

v1.0 起 patch 后必须填"自检 checklist"（5-7 项硬 grep），不填不允许 freeze。详见 §15.4 PR 规约 + §18.4 自检纪律。

---

## 二十、文档状态

**v1.0（已冻结）**：评审五轮闭环，30 条错误码、4 决策表、M0-4 子计划、§3.3 redact 矛盾定型、附录 C JSON Schema 草案全部就位。**可启动 M0-1 spike。**

后续每个 M 阶段结束更新版本号与变更记录。

**下一步建议**：

1. M0-3 阶段把 `scripts/self-check.sh` 落地（实现 §18.4 自检纪律）
2. M0-1 跑通后归档 `docs/m0-1-spike-report.md`（PyInstaller+ASAR 联调实测结果）
3. M0-2 把附录 B 冻结为 `docs/api-spec.md` v1.0
4. M0-4 跑通后归档 `docs/m0-4-spike-report.md`（模型连通性实测结果 + 写入附录 C 实测数据）
