# Update: 2024-08-19T14:24:52.641181Z
FROM intelanalytics/ipex-llm-inference-cpp-xpu:latest

RUN mkdir -p /llm/ollama && cd /llm/ollama && init-ollama

COPY entrypoint.sh /llm/entrypoint.sh


RUN addgroup --gid 1000 ipex && \
    adduser --uid 1000 --ingroup ipex --disabled-password ipex && \
    apt update && apt install  -y tzdata ca-certificates gosu && \
    apt clean && chmod +x /llm/entrypoint.sh

ENTRYPOINT ["bash", "/llm/entrypoint.sh"]