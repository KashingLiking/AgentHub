# AgentHub 项目结构说明
 
> 本文档详细说明每个文件夹和关键文件的作用,帮助快速理解项目架构。
 
---
 
## 📁 项目根目录
 
```
AgentHub-AllInOne/
├── backend/              # 后端服务 (FastAPI + Python)
├── frontend/             # 前端应用 (Vue 3 + TypeScript + Vite)
├── runtime/              # Docker 运行时环境配置
├── docs/                 # 项目文档和图片资源
├── ai-agent-devlog/      # AI Agent 开发日志
├── All_Things_YOU_NEED_TO_KNOW/  # 完整的项目文档、视频、图片
├── start.sh              # 一键启动脚本 (前端+后端)
├── stop.sh               # 一键停止脚本
├── run.py                # 后端启动入口
└── README.md             # 项目说明
```
 
---
 
## 🔧 后端 (backend/)
 
### 核心架构层
 
#### `adapters/` - 适配器层
各 LLM 提供商的统一适配接口层。
- `base.py` - 适配器基类,定义统一接口
- `claude.py` - Anthropic Claude 适配器
- `codex.py` - OpenAI Codex 适配器
- `opencode.py` - 自定义 OpenCode 适配器
- `custom.py` - 通用自定义适配器
- `mcp_client.py` - MCP (Model Context Protocol) 客户端
- `registry.py` - 适配器注册表,动态加载适配器
- `events.py` - 流式事件定义 (SSE 事件类型)
 
#### `api/` - API 路由层
FastAPI 路由和依赖注入。
- `deps.py` - 依赖注入 (认证、数据库会话等)
- `exception_handlers.py` - 全局异常处理器
- `middleware/` - 中间件 (CORS、日志、认证等)
- `v1/` - API v1 版本路由
  - `auth.py` - 认证相关 (登录、注册、Token 刷新)
  - `chat.py` - 聊天相关 (发消息、SSE 流式响应)
  - `agents.py` - Agent 管理
  - `conversations.py` - 会话管理
  - `skills.py` - Skill 管理
  - `workflows.py` - Workflow 管理
  - `mcp.py` - MCP 服务器管理
 
#### `core/` - 核心基础设施
框架无关的基础设施代码。
- `database.py` - 数据库连接池和会话管理
- `redis.py` - Redis 连接和分布式锁
- `logging.py` - 结构化日志配置
- `exceptions.py` - 自定义异常类
- `events.py` - 事件总线 (领域事件)
- `circuit_breaker.py` - 熔断器 (防止级联故障)
- `lock.py` - 分布式锁实现
- `avatars.py` - 头像生成工具
- `frontmatter.py` - Markdown frontmatter 解析
- `utils.py` - 通用工具函数
 
#### `domain/` - 领域模型
业务逻辑的核心领域对象 (DDD 风格)。
- `agent.py` - Agent 领域模型 (属性、行为、业务规则)
- `conversation.py` - 会话领域模型
- `message.py` - 消息领域模型
- `skill.py` - Skill 领域模型
- `prompt.py` - Prompt 领域模型
- `thread.py` - Thread 领域模型
- `memory.py` - Memory 领域模型
 
#### `models/` - 数据库 ORM 模型
SQLAlchemy ORM 模型定义 (数据层)。
- `base.py` - ORM 基类 (时间戳、软删除等)
- `user.py` - 用户表
- `agent.py` - Agent 表
- `conversation.py` - 会话表
- `message.py` - 消息表
- `skill.py` - Skill 表
- `agent_skill.py` - Agent-Skill 关联表 (多对多)
- `conversation_agent.py` - Conversation-Agent 关联表
- `mcp_server.py` - MCP 服务器配置表
- `workflow.py` - Workflow 表
- `thread.py` - Thread 表
- `audit_log.py` - 审计日志表
- `read_receipt.py` - 消息已读回执表
- `prompt.py` - Prompt 模板表
 
#### `repositories/` - 仓储层
数据访问层,封装数据库操作 (Repository Pattern)。
- `base.py` - 仓储基类 (通用 CRUD)
- `user_repo.py` - 用户仓储
- `agent_repo.py` - Agent 仓储
- `conversation_repo.py` - 会话仓储
- `message_repo.py` - 消息仓储
- `skill_repo.py` - Skill 仓储
- `prompt_repo.py` - Prompt 仓储
- `workflow_repo.py` - Workflow 仓储
- `mcp_server_repo.py` - MCP 服务器仓储
- `memory_repo.py` - Memory 仓储
- `checkpoint_repo.py` - Checkpoint 仓储 (会话状态快照)
- `preview_repo.py` - Preview 仓储 (产物预览)
- `stream_buffer_repo.py` - 流式缓冲区仓储
- `read_receipt_repo.py` - 已读回执仓储
- `thread_repo.py` - Thread 仓储
 
#### `schemas/` - Pydantic Schema
API 请求/响应的数据验证模型。
- `auth.py` - 认证相关 Schema (登录、注册、Token)
- `agent.py` - Agent Schema
- `conversation.py` - 会话 Schema
- `message.py` - 消息 Schema
- `chat.py` - 聊天 Schema
- `skill.py` - Skill Schema
- `prompt.py` - Prompt Schema
- `workflow.py` - Workflow Schema
- `mcp_server.py` - MCP 服务器 Schema
- `artifact.py` - 产物 Schema (代码、图表等)
- `orchestrator_tools.py` - Orchestrator 工具定义
- `response.py` - 统一响应格式
- `ws.py` - WebSocket 消息格式
 
#### `services/` - 服务层
业务逻辑层,协调多个仓储完成复杂业务。
- `auth_service.py` - 认证服务 (JWT、密码哈希)
- `agent_service.py` - Agent 服务 (创建、更新、删除)
- `agent_builder_service.py` - Agent 构建服务 (动态生成 Agent)
- `conversation_service.py` - 会话服务
- `message_service.py` - 消息服务
- `chat_service.py` - 聊天服务 (消息分流、路由)
- `skill_service.py` - Skill 服务
- `prompt_service.py` - Prompt 服务
- `workflow_service.py` - Workflow 服务
- `memory_service.py` - Memory 服务
- `stream_service.py` - 流式服务 (SSE 推送)
- `thread_service.py` - Thread 服务
- `preview_service.py` - 产物预览服务
- `diff_service.py` - Diff 生成服务
- `diff_apply_service.py` - Diff 应用服务 (合并代码)
- `docker_runtime.py` - Docker 运行时服务 (应用部署)
- `orchestrator/` - Orchestrator 核心实现
  - `orchestrator.py` - 主 Agent 编排器
  - `tools.py` - Orchestrator 可用工具定义
  - `memory.py` - Orchestrator 记忆管理
 
### 基础设施
 
#### `hooks/` - Hook 系统
工具调用前后的拦截器 (AOP 风格)。
- `base.py` - Hook 基类
- `manager.py` - Hook 管理器 (注册、触发)
- `pre_execution.py` - 工具执行前 Hook (参数验证、权限检查)
- `approval.py` - 审批 Hook (危险操作需人工审批)
- `post_execution.py` - 工具执行后 Hook (结果记录、通知)
 
#### `migrations/` - 数据库迁移
Alembic 数据库版本控制。
- `env.py` - Alembic 环境配置
- `versions/` - 迁移版本文件 (自动生成)
 
#### `seeds/` - 数据种子
初始化数据脚本。
- `agents.py` - 内置 Agent 种子数据 (Orchestrator 等)
- `mcp_servers.py` - 内置 MCP 服务器配置
- `users.py` - 测试用户数据
 
#### `tests/` - 测试
单元测试和集成测试。
- `conftest.py` - Pytest 配置和 fixtures
- `unit/` - 单元测试
- `integration/` - 集成测试
 
### 配置和资源
 
#### `prompts/` - Prompt 模板
Agent 和 Orchestrator 的系统 Prompt。
- `orchestrator.md` - Orchestrator 系统 Prompt (核心)
- `sub_agent_spawn.md` - 子 Agent 生成 Prompt
- `agent_builder.md` - Agent 构建器 Prompt
- `local_edit.md` - 本地编辑 Prompt
- `agents/` - 各个 Agent 的专属 Prompt
 
#### `skills/` - Skill 定义
可复用的技能知识库 (Markdown 格式)。
- `code_review.md` - 代码审查 Skill
- `data_analysis_workflow.md` - 数据分析流程
- `python_expert.md` - Python 专家知识
- `security_audit.md` - 安全审计
- `web_app_development_workflow.md` - Web 应用开发流程
- `meme_library.json` - 表情包库 (闲聊专用)
 
#### `squads/` - Squad 模板
预定义的 Agent 小队配置 (JSON 格式)。
- `chat_squad.json` - 闲聊小队 (年姐、夕妹、余弟、望哥)
- `dev_squad.json` - 开发小队 (代码审查、部署等)
- `data_squad.json` - 数据分析小队
 
#### `static/` - 静态资源
静态文件服务。
- `avatars/` - Agent 头像图片
- `common.py` - 静态文件工具
 
#### `memes/` - 表情包资源
闲聊 Agent 使用的表情包图片。
 
### 配置文件
 
- `main.py` - FastAPI 应用入口
- `config.py` - 应用配置 (从环境变量读取)
- `.env` - 环境变量配置 (本地,不提交 Git)
- `.env.example` - 环境变量模板 (提交 Git)
- `alembic.ini` - Alembic 配置
- `requirements.txt` - Python 依赖
- `requirements-dev.txt` - 开发依赖
- `pytest.ini` - Pytest 配置
 
---
 
## 🎨 前端 (frontend/)
 
### 核心代码
 
#### `src/api/` - API 请求层
所有后端 API 调用封装,组件不直接 fetch。
- `http.ts` - Axios 实例配置 (拦截器、Token 刷新)
- `auth.ts` - 认证 API (登录、注册、登出)
- `chat.ts` - 聊天 API (发送消息、获取历史)
- `agent.ts` - Agent 管理 API
- `conversation.ts` - 会话管理 API
- `skill.ts` - Skill 管理 API
- `workflow.ts` - Workflow 管理 API
- `sse.ts` - SSE 客户端封装 (流式事件接收)
 
#### `src/components/` - Vue 组件
按模块组织的可复用组件。
- `layout/` - 布局组件 (导航栏、侧边栏)
- `chat/` - 聊天相关组件
  - `MessageList.vue` - 消息列表
  - `MessageItem.vue` - 单条消息
  - `ChatInput.vue` - 消息输入框
  - `AgentAvatar.vue` - Agent 头像
- `agents/` - Agent 管理组件
  - `AgentCard.vue` - Agent 卡片
  - `AgentEditor.vue` - Agent 编辑器
- `artifacts/` - 产物组件
  - `CodeBlock.vue` - 代码块 (语法高亮)
  - `DiffCard.vue` - Diff 显示卡片
  - `PreviewCard.vue` - 产物预览 (HTML/图表)
  - `ApprovalPanel.vue` - 审批面板
- `common/` - 通用组件
  - `Button.vue`
  - `Modal.vue`
  - `Loading.vue`
 
#### `src/composables/` - 组合式函数
可复用逻辑 (Vue 3 Composition API)。
- `useChat.ts` - 聊天逻辑 (发送消息、SSE 连接、停止生成)
- `useAuth.ts` - 认证逻辑 (登录、登出、Token 管理)
- `useAgent.ts` - Agent 管理逻辑
- `useConversation.ts` - 会话管理逻辑
- `useWorkflow.ts` - Workflow 逻辑
- `useTheme.ts` - 主题切换逻辑
 
#### `src/stores/` - Pinia 状态管理
全局状态 (Pinia)。
- `auth.ts` - 认证状态 (用户信息、Token)
- `chat.ts` - 聊天状态 (流式状态、blocks、streamingAgents)
- `conversation.ts` - 会话列表状态
- `agent.ts` - Agent 列表状态
- `ui.ts` - UI 状态 (右栏展开、diffCardStates)
- `theme.ts` - 主题状态 (亮/暗模式、品牌色)
- `deployments.ts` - 部署状态
 
#### `src/views/` - 页面组件
路由对应的页面级组件。
- `LoginView.vue` - 登录页
- `RegisterView.vue` - 注册页
- `ChatView.vue` - 聊天主页
- `AgentManageView.vue` - Agent 管理页
- `SkillManageView.vue` - Skill 管理页
- `ConversationListView.vue` - 会话列表页
- `WorkflowView.vue` - Workflow 页
 
#### `src/types/` - TypeScript 类型定义
与后端 Schema 对齐的类型定义。
- `auth.ts` - 认证类型
- `agent.ts` - Agent 类型
- `conversation.ts` - 会话类型
- `message.ts` - 消息类型
- `skill.ts` - Skill 类型
- `workflow.ts` - Workflow 类型
- `sse.ts` - SSE 事件类型
 
#### `src/router/` - 路由配置
Vue Router 配置。
- `index.ts` - 路由定义和导航守卫
 
#### `src/i18n/` - 国际化
Vue I18n 配置。
- `index.ts` - i18n 实例配置
 
#### `src/locales/` - 语言包
多语言翻译。
- `zh-CN.ts` - 简体中文
- `en.ts` - 英文
 
#### `src/utils/` - 工具函数
通用工具函数。
- `format.ts` - 格式化工具 (日期、文件大小)
- `markdown.ts` - Markdown 渲染
- `syntax-highlight.ts` - 代码高亮
- `color.ts` - 颜色工具
 
#### `src/assets/` - 静态资源
图片、字体等静态资源。
 
### 配置文件
 
- `src/main.ts` - 应用入口
- `src/App.vue` - 根组件
- `vite.config.ts` - Vite 配置
- `tsconfig.json` - TypeScript 配置
- `package.json` - npm 依赖和脚本
- `.env.development` - 开发环境变量
- `.env.example` - 环境变量模板
- `CLAUDE.md` - 项目开发规范 (给 AI 看)
 
#### `mock/` - Mock 数据
Vite Mock 插件的 mock 数据。
- `api.ts` - API mock
- `files.ts` - 文件系统 mock
 
---
 
## 🐳 运行时 (runtime/)
 
Docker 容器运行时环境,用于部署 Agent 生成的应用。
 
- `Dockerfile` - 应用容器镜像定义
- `.dockerignore` - Docker 构建忽略文件
- `README.md` - 运行时说明
 
---
 
## 📚 文档 (All_Things_YOU_NEED_TO_KNOW/)
 
完整的项目文档、开发日志、演示视频和截图。
 
### 核心文档
 
- `AgentHub架构介绍.md` - 架构完整介绍 (核心文档)
- `AgentHub_架构现状报告.html` - 架构现状报告
- `主Agent设计.md` - Orchestrator 设计文档
- `数据结构设计-MVP草案v1.md` - 数据库设计
- `Auth全栈实现总结.md` - 认证系统实现总结
- `本地开发配置.md` - 本地开发配置指南
 
### 开发日志
 
- `开发日志 1 — 架构选型.md` - 技术选型决策
- `开发日志 2 - 前端架构设计.md` - 前端架构设计
- `开发日志 3 - 后端架构设计.md` - 后端架构设计
- `开发日志 - Agent管理与Skill子系统实现.md` - Agent/Skill 实现
- `开发日志 - 适配器层与MCP服务实现.md` - 适配器层实现
- `开发日志 - 消息显示Bug修复与UI优化.md` - Bug 修复日志
 
### 需求和进度
 
- `AgentHub 5.27 开发进度汇总.md` - 开发进度
- `AgentHub 6.2 需求汇总.md` - 需求汇总
 
### 演示视频 (demovideo/)
 
- `架构介绍.mp4` - 架构介绍视频
- `ai协作展示.mp4` - AI 协作演示
- `代码小队展示.mp4` - 代码小队演示
- `数据分析小队功能.mp4` - 数据分析演示
- `闲聊小队展示.mp4` - 闲聊演示
- `Agent功能.mp4` - Agent 功能演示
- `Skill功能.mp4` - Skill 功能演示
 
### 截图 (imgshow/)
 
- `流程图.png` - 系统流程图
- `agents管理页面.png` - Agent 管理界面
- `agents新建页面.png` - Agent 创建界面
- `Skill管理页面.png` - Skill 管理界面
- `会话创建与模板群聊可选择页面.png` - 会话创建
- `群聊模式下会话管理与Token计数.png` - 会话管理
- `代码diff和权限审批.png` - Diff 和审批
- `多文件格式的预览与手动编辑的支持.png` - 产物预览
- `会话级沙盒文件系统.png` - 沙盒文件系统
- `基于workflow的完整trace.png` - Workflow trace
- `成功部署前后端小应用且于容器中正常允许.png` - 应用部署
- `贡献者.png` - 贡献者信息
 
### 调研资料 (preDoc/)
 
前期技术调研文档。
- `01-多Agent协作框架/` - Agent 协作框架调研
- `02-适配器层与CLI集成/` - 适配器层调研
- `03-IM平台与Web前端/` - IM 平台调研
- `04-Prompt工程与Agent角色/` - Prompt 工程调研
- `05-工程化三件套/` - 工程化调研
- `06-可观测性与Trace/` - 可观测性调研
- `调研结果模板.md` - 调研模板
 
---
 
## 🚀 启动脚本
 
### `start.sh` - 一键启动
自动启动 MySQL、后端、前端服务。
 
### `stop.sh` - 一键停止
停止所有服务。
 
### `run.py` - 后端启动入口
从项目根目录启动后端 (自动设置 PYTHONPATH)。
 
### `start_backend.sh` - 后端单独启动
仅启动后端服务 (历史遗留,推荐用 start.sh)。
 
---
 
## 📝 其他文档
 
### `README.md` - 项目说明
项目简介、快速开始、贡献者信息。
 
### `SETUP_GUIDE.md` - 快速启动指南
新用户快速配置和启动项目的指南 (你创建的)。
 
### `TROUBLESHOOTING.md` - 故障排查
常见问题和解决方案 (你创建的)。
 
### `AGENTHUB.md` - 项目概述
项目定位和核心概念说明。
 
---
 
## 🎯 关键文件速查
 
### 后端核心
 
| 文件 | 作用 |
|------|------|
| `backend/main.py` | FastAPI 应用入口 |
| `backend/config.py` | 应用配置加载 |
| `backend/services/orchestrator/orchestrator.py` | Orchestrator 核心实现 |
| `backend/services/chat_service.py` | 聊天消息分流器 |
| `backend/prompts/orchestrator.md` | Orchestrator 系统 Prompt |
| `backend/hooks/approval.py` | 审批 Hook (危险操作拦截) |
| `backend/adapters/registry.py` | LLM 适配器注册表 |
 
### 前端核心
 
| 文件 | 作用 |
|------|------|
| `frontend/src/main.ts` | Vue 应用入口 |
| `frontend/src/App.vue` | 根组件 |
| `frontend/src/composables/useChat.ts` | 聊天核心逻辑 (SSE 连接、消息发送) |
| `frontend/src/stores/chat.ts` | 聊天状态管理 (流式状态) |
| `frontend/src/api/sse.ts` | SSE 客户端封装 |
| `frontend/src/views/ChatView.vue` | 聊天主界面 |
 
### 配置文件
 
| 文件 | 作用 |
|------|------|
| `backend/.env` | 后端环境变量 (数据库、API Key) |
| `frontend/.env.development` | 前端开发环境变量 |
| `backend/alembic.ini` | 数据库迁移配置 |
| `frontend/vite.config.ts` | Vite 构建配置 |
 
---
 
## 📊 技术栈总结
 
### 后端
- **框架**: FastAPI (Python 3.11+)
- **数据库**: MySQL + SQLAlchemy ORM
- **缓存**: Redis
- **迁移**: Alembic
- **日志**: Structlog
- **测试**: Pytest
- **LLM**: Anthropic Claude / OpenAI / 自定义
 
### 前端
- **框架**: Vue 3 (Composition API)
- **语言**: TypeScript
- **构建**: Vite
- **状态**: Pinia
- **路由**: Vue Router
- **UI**: Element Plus + Tailwind CSS
- **国际化**: Vue I18n
- **代码高亮**: Shiki
- **Markdown**: markdown-it
 
### 运行时
- **容器**: Docker
- **编排**: Docker Compose (未来)
 
---
 
## 🔄 数据流向
 
```
用户 → 前端 Vue → API (REST/SSE) → 后端 FastAPI
                                    ↓
                            ChatService (消息分流)
                                    ↓
                            Orchestrator (主 Agent)
                                    ↓
                            子 Agent (并行执行)
                                    ↓
                            工具调用 (Hook 拦截)
                                    ↓
                            SSE 推送 → 前端 → 用户
```
 
---
 
## 📖 阅读建议
 
### 新手入门
1. 先读 `README.md` 了解项目定位
2. 读 `SETUP_GUIDE.md` 快速启动项目
3. 读 `AgentHub架构介绍.md` 理解核心架构
4. 看 `demovideo/` 里的演示视频
 
### 后端开发
1. 先看 `backend/main.py` 了解应用入口
2. 读 `backend/services/orchestrator/orchestrator.py` 理解核心逻辑
3. 读 `backend/prompts/orchestrator.md` 理解 Prompt 设计
4. 看 `backend/adapters/` 理解 LLM 适配
 
### 前端开发
1. 先看 `frontend/CLAUDE.md` 了解开发规范
2. 读 `frontend/src/composables/useChat.ts` 理解聊天逻辑
3. 读 `frontend/src/api/sse.ts` 理解 SSE 实现
4. 看 `frontend/src/views/ChatView.vue` 理解 UI 组织
 