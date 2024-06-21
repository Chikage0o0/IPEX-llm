## Intel Ipex llm run in docker
开箱即用 Intel 显卡的OpenWebUI、Ollama镜像  
提供了额外的PUID、PGID以及UMASK环境变量，并持久化目录至`/opt/ipex/workspace`。

```shell
docker run -d \
  --name=ipex-llm \
  --device=/dev/dri \
  --net=bridge \
  -e DEVICE=iGPU \
  -e TZ=Asia/Shanghai \
  -p 8080:8080 \
  -v /opt/ipex/workspace:/opt/ipex/workspace \
  --restart unless-stopped \
  ghcr.io/chikage0o0/ipex-llm:latest
```
