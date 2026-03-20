# Yogurt Docker

Yogurt 的 Docker 部署方案，基于 [acidify-core](https://github.com/LagrangeDev/acidify) 实现的 QQ 协议端。

## 前置要求

- Docker 和 Docker Compose
- 一个可用的[签名 API 服务](https://acidify.ntqqrev.org/yogurt/signing)

## 快速开始

1. 克隆本仓库：
```bash
git clone https://github.com/your-repo/yogurt-docker.git
cd yogurt-docker
```

2. 复制并编辑配置文件：
```bash
cp config.json.example config.json
# 根据实际情况修改 config.json
```

3. 创建数据目录：
```bash
mkdir -p data
```

4. 启动容器：
```bash
docker compose up -d
```

5. 查看日志：
```bash
docker compose logs -f
```

## 配置说明

编辑 `config.json` 配置文件，关键配置项：

| 配置项 | 说明 |
|--------|------|
| `protocol.uin` | 你的 QQ 号 |
| `protocol.password` | QQ 密码（使用 Android 协议时必填） |
| `protocol.os` | 协议类型：`Windows`、`Mac`、`Linux`、`AndroidPhone`、`AndroidPad` |
| `protocol.signApiUrl` | 签名 API 服务地址（必填） |
| `milky.http.port` | HTTP 服务端口（默认 3000） |
| `milky.http.accessToken` | 访问令牌（建议生产环境设置） |

完整配置说明请参阅 [Yogurt 配置文档](https://acidify.ntqqrev.org/yogurt/configuration)。

## 数据持久化

会话数据存储在 `./data` 目录：
- `session-store.json` - PC 协议会话
- `session-store-android.json` - Android 协议会话

## Milky 协议

Yogurt 实现了 [Milky 协议](https://milky.ntqqrev.org/)，提供 HTTP 和 WebSocket 接口，可对接各种 QQ 机器人框架。

## 安全建议

- 生产环境请设置 `milky.http.accessToken`
- 妥善保管 `config.json` 和会话文件
- 容器默认以非 root 用户运行

## 许可证

Yogurt 基于 [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html) 开源。
