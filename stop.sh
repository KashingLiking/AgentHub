#!/bin/bash

echo "停止后端..."
pkill -f "uvicorn backend.main:app" 2>/dev/null && echo "后端已停止" || echo "后端未在运行"

echo "停止前端..."
pkill -f "vite" 2>/dev/null && echo "前端已停止" || echo "前端未在运行"
