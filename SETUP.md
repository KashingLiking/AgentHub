# AgentHub 快速启动指南
 
1. Python 3.11.15 安装
2. Python 虚拟环境创建 (`backend/.venv`)
3.  `.env` 配置文件创建
 
## ⚠️ 需要您完成的配置
 
### 1. 修改 `backend/.env` 文件
 
打开 `backend/.env`,修改以下两个关键配置:
 
```bash
# 修改 MySQL 密码(将 CHANGE_ME 改为您的实际密码)
DB_URL=mysql+pymysql://root:CHANGE_ME@localhost:3306/agenthub
 
# 修改 Anthropic API Key(将 CHANGE_ME 改为您的实际 API Key)
EXTERNAL_API_KEY=CHANGE_ME
```
 
**获取 Anthropic API Key:**
- 访问: https://console.anthropic.com/settings/keys
- 如果没有账号,需要先注册
 
**如果没有 Anthropic API Key,可以使用国内替代方案:**
```bash
# 方案1: Moonshot Kimi (国内可直连)
EXTERNAL_API_BASE=https://api.moonshot.cn/anthropic
EXTERNAL_API_KEY=sk-xxx  # 从 https://platform.moonshot.cn 获取
EXTERNAL_MODEL=kimi-k2.5
 
# 方案2: 智谱 GLM
EXTERNAL_API_BASE=https://open.bigmodel.cn/api/anthropic
EXTERNAL_API_KEY=你的key
EXTERNAL_MODEL=glm-5
```
 
### 2. 初始化数据库
 
依赖安装完成后,运行:
 
```bash
cd backend
source .venv/bin/activate
alembic upgrade head
```
 
### 3. 安装前端依赖
 
```bash
cd frontend
npm install
```
 
## 🚀 启动服务
 
### 启动后端 (在项目根目录)
 
```bash
python3.11 run.py
```
 
访问: http://localhost:18888/docs (Swagger API 文档)
 
### 启动前端
 
```bash
cd frontend
npm run dev
```
 
访问: http://localhost:5173
 
## ❓ 常见问题
 
### MySQL 连接失败?
- 确认 MySQL 服务已启动: `brew services list | grep mysql`
- 如果未启动: `brew services start mysql`
- 测试连接: `mysql -u root -p`
 
### 没有 Anthropic API Key?
- 使用 Moonshot Kimi 免费额度(见上方配置)
- 或先跳过,体验前端界面
 
### 端口被占用?
- 修改 `backend/.env` 中的 `PORT=8000` 为其他端口
 
## 📝 下一步
 
配置完成后:
1. 注册账号 (http://localhost:5173)
2. 创建一个新的群聊会话
3. 向 Orchestrator 提问,体验多 Agent 协作!