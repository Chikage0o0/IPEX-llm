# Update: 2025-02-13T13:57:50.263787Z
FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

RUN mkdir -p /llm/ollama && cd /llm/ollama && init-ollama

COPY entrypoint.sh /llm/entrypoint.sh


RUN addgroup --gid 1000 ipex && \
    adduser --uid 1000 --ingroup ipex --disabled-password ipex && \
    apt update && apt install  -y tzdata ca-certificates gosu && \
    apt clean && chmod +x /llm/entrypoint.sh

ENTRYPOINT ["bash", "/llm/entrypoint.sh"]