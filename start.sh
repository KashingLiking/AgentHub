#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "启动后端..."
cd "$PROJECT_DIR"
backend/.venv/bin/uvicorn backend.main:app --host 0.0.0.0 --port 18888 --reload > backend/backend.log 2>&1 &
echo "后端 PID: $!"

echo "启动前端..."
cd "$PROJECT_DIR/frontend"
npm run dev > /tmp/frontend.log 2>&1 &
echo "前端 PID: $!"

echo ""
echo "启动完成："
echo "  前端: http://localhost:5173"
echo "  后端: http://localhost:18888/docs"
