# Yogurt Docker

Yogurt 的 Docker 部署方案，基于 [acidify-core](https://github.com/LagrangeDev/acidify) 实现的 QQ 协议端。

## 快速开始

### 方法一：Docker Compose（推荐）

1. 创建项目目录：

```bash
mkdir yogurt && cd yogurt
```

2. 创建 `docker-compose.yml`：

```yaml
services:
  yogurt:
    image: ghcr.io/shoucandanghehe/yogurt-docker:latest
    container_name: yogurt
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - ./config.json:/app/config.json
      - ./data:/app/data
```

3. 首次运行生成默认配置：

```bash
docker compose up
# 看到 "Default config.json created" 后按 Ctrl+C 停止
```

4. 编辑 `config.json`，填写必要信息（QQ号、签名API地址等）

5. 重新启动服务：

```bash
docker compose up -d
```

6. 查看日志：

```bash
docker compose logs -f
```

### 方法二：Docker Run

1. 创建数据目录：

```bash
mkdir -p data
```

2. 首次运行生成默认配置：

```bash
docker run --rm \
  -v $(pwd)/config.json:/app/config.json \
  -v $(pwd)/data:/app/data \
  ghcr.io/shoucandanghehe/yogurt-docker:latest
# 看到 "Default config.json created" 即可
```

3. 编辑 `config.json`，填写必要信息

4. 启动容器：

```bash
docker run -d \
  --name yogurt \
  --restart unless-stopped \
  -v $(pwd)/config.json:/app/config.json \
  -v $(pwd)/data:/app/data \
  -p 3000:3000 \
  ghcr.io/shoucandanghehe/yogurt-docker:latest
```

5. 查看日志：

```bash
docker logs -f yogurt
```

## 配置说明

请参阅 [Yogurt 配置文档](https://acidify.ntqqrev.org/yogurt/configuration)。

## 数据持久化

会话数据存储在 `./data` 目录：

- `session-store.json` - PC 协议会话
- `session-store-android.json` - Android 协议会话

## 更新镜像

### Docker Compose

```bash
docker compose pull
docker compose up -d
```

### Docker Run

```bash
docker pull ghcr.io/shoucandanghehe/yogurt-docker:latest
docker stop yogurt
docker rm yogurt
# 然后重新执行 docker run 命令
```

## Milky 协议

Yogurt 实现了 [Milky 协议](https://milky.ntqqrev.org/)，提供 HTTP 和 WebSocket 接口，可对接各种 QQ 机器人框架。

## 安全建议

- 生产环境请设置 `milky.http.accessToken`
- 妥善保管 `config.json` 和会话文件
- 容器默认以非 root 用户运行

## 许可证

Yogurt 基于 [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html) 开源。
