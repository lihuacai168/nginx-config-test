#!/bin/bash

# 设置端口变量，默认为8080，但可以通过环境变量覆盖
PORT=${PORT:-8080}

echo "使用端口: $PORT"
echo "修改docker-compose.yml中的端口映射..."
sed -i.bak "s/- \"80:80\"/- \"$PORT:80\"/" docker-compose.yml

echo "启动容器..."
docker-compose up -d

echo "等待服务启动..."
sleep 3

echo "======================= 测试场景 1 ======================="
echo "location /api1/ 和 proxy_pass http://backend:8000/"

echo "情况A - 请求: /api1/users (标准路径，带尾部斜杠的location匹配)"
curl -s http://localhost:$PORT/api1/users | jq
echo ""

echo "情况B - 请求: /api1/ (仅尾部斜杠)"
curl -s http://localhost:$PORT/api1/ | jq
echo ""

echo "情况C - 请求: /api1 (不带尾部斜杠 - 关键区别点)"
curl -s http://localhost:$PORT/api1 | jq
echo ""

echo "情况D - 请求: /api1/nested/path (多级路径)"
curl -s http://localhost:$PORT/api1/nested/path | jq
echo ""

echo "情况E - 请求: /api1/users?id=123 (带查询参数)"
curl -s "http://localhost:$PORT/api1/users?id=123" | jq
echo ""

echo "======================= 测试场景 3 ======================="
echo "location /api3 和 proxy_pass http://backend:8000/"

echo "情况A - 请求: /api3/users (标准路径)"
curl -s http://localhost:$PORT/api3/users | jq
echo ""

echo "情况B - 请求: /api3/ (带尾部斜杠)"
curl -s http://localhost:$PORT/api3/ | jq
echo ""

echo "情况C - 请求: /api3 (不带尾部斜杠 - 关键区别点)"
curl -s http://localhost:$PORT/api3 | jq
echo ""

echo "情况D - 请求: /api3/nested/path (多级路径)"
curl -s http://localhost:$PORT/api3/nested/path | jq
echo ""

echo "情况E - 请求: /api3/users?id=123 (带查询参数)"
curl -s "http://localhost:$PORT/api3/users?id=123" | jq
echo ""

echo "======================= 其他场景测试 ======================="
echo "======================= 测试场景 2 ======================="
echo "location /api2/ 和 proxy_pass http://backend:8000"

echo "请求: /api2/users"
curl -s http://localhost:$PORT/api2/users | jq
echo ""

echo "请求: /api2/"
curl -s http://localhost:$PORT/api2/ | jq
echo ""

echo "请求: /api2 (不带尾部斜杠)"
curl -s http://localhost:$PORT/api2 | jq
echo ""

echo "======================= 测试场景 4 ======================="
echo "location /api4 和 proxy_pass http://backend:8000"

echo "请求: /api4/users"
curl -s http://localhost:$PORT/api4/users | jq
echo ""

echo "请求: /api4/"
curl -s http://localhost:$PORT/api4/ | jq
echo ""

echo "请求: /api4"
curl -s http://localhost:$PORT/api4 | jq
echo ""

echo "测试完成"
echo "恢复docker-compose.yml..."
mv docker-compose.yml.bak docker-compose.yml 