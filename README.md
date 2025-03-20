# Nginx Location和Proxy_Pass斜杠组合测试

这个项目用于测试Nginx中四种不同的`location`和`proxy_pass`配置组合（带斜杠和不带斜杠）的行为区别。

## 配置组合

1. `location /api1/` 和 `proxy_pass http://backend:8000/`（两者都带斜杠）
2. `location /api2/` 和 `proxy_pass http://backend:8000`（location带斜杠，proxy_pass不带）
3. `location /api3` 和 `proxy_pass http://backend:8000/`（location不带斜杠，proxy_pass带）
4. `location /api4` 和 `proxy_pass http://backend:8000`（两者都不带斜杠）

## 关于场景1和场景3的关键区别

虽然场景1和场景3在某些请求上表现相似，但它们有一个重要区别：

- **场景1 (`location /api1/`)**：
  - 使用带尾部斜杠的location，**只匹配**以 `/api1/` 开头的路径
  - **不会匹配** `/api1`（不带尾部斜杠）的请求
  - 访问 `/api1` 时将匹配其他location块或默认location

- **场景3 (`location /api3`)**：
  - 使用不带尾部斜杠的location，匹配所有以 `/api3` 开头的路径
  - 同时匹配 `/api3` 和 `/api3/` 两种形式的请求

这个区别在URL设计和API版本控制中非常重要，测试脚本中特别添加了测试用例来展示这一点。

## 如何运行

### 手动测试

1. 确保安装了Docker和Docker Compose
2. 运行以下命令启动服务:

```bash
docker-compose up --build
```

3. 在浏览器中访问 http://localhost
4. 在页面上点击各个测试链接，观察不同配置下的行为

### 自动测试

项目提供了一个自动化测试脚本，可以通过命令行快速测试所有场景：

```bash
# 使用默认端口8080
chmod +x test.sh
./test.sh

# 使用自定义端口
PORT=9090 ./test.sh
```

注意：自动测试脚本需要安装`jq`工具来格式化JSON输出。

## 预期结果

1. **情况1** (`location /api1/` 和 `proxy_pass http://backend:8000/`):
   - `/api1/users` 会转发到 `/users`
   - `/api1/` 会转发到 `/`
   - `/api1` 不会匹配这个location，会被其他规则处理

2. **情况2** (`location /api2/` 和 `proxy_pass http://backend:8000`):
   - `/api2/users` 会转发到 `/api2/users`
   - `/api2/` 会转发到 `/api2/`
   - `/api2` 不会匹配这个location

3. **情况3** (`location /api3` 和 `proxy_pass http://backend:8000/`):
   - `/api3/users` 会转发到 `/users`
   - `/api3/` 会转发到 `/`
   - `/api3` 会转发到 `/`（这是与情况1的关键区别）

4. **情况4** (`location /api4` 和 `proxy_pass http://backend:8000`):
   - `/api4/users` 会转发到 `/api4/users`
   - `/api4/` 会转发到 `/api4/`
   - `/api4` 会转发到 `/api4`

## 系统组件

- **Nginx**: 配置了四种不同的location和proxy_pass组合
- **后端服务**: 一个简单的Flask应用，显示接收到的请求路径 