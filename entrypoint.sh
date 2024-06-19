#!/bin/sh

if [ -z "${PGID}" ]; then
    PGID="`id -g ipex`"
fi

if [ -z "${PUID}" ]; then
    PUID="`id -u ipex`"
fi

if [ -z "${UMASK}" ]; then
    UMASK="022"
fi

if [ -z "${WORK_SPACE}" ]; then
    WORK_SPACE="/opt/ipex/workspace"
fi



echo "=================== 启动参数 ==================="
echo "USER_GID = ${PGID}"
echo "USER_UID = ${PUID}"
echo "UMASK = ${UMASK}"
echo "WORK_SPACE = ${WORK_SPACE}"
echo "==============================================="


# 更新用户GID?
if [ -n "${PGID}" ] && [ "${PGID}" != "`id -g ipex`" ]; then
    echo "更新用户GID..."
    sed -i -e "s/^ipex:\([^:]*\):[0-9]*/ipex:\1:${PGID}/" /etc/group
    sed -i -e "s/^ipex:\([^:]*\):\([0-9]*\):[0-9]*/ipex:\1:\2:${PGID}/" /etc/passwd
fi

# 更新用户UID?
if [ -n "${PUID}" ] && [ "${PUID}" != "`id -u ipex`" ]; then
    echo "更新用户UID..."
    sed -i -e "s/^ipex:\([^:]*\):[0-9]*:\([0-9]*\)/ipex:\1:${PUID}:\2/" /etc/passwd
fi

# 更新umask?
if [ -n "${UMASK}" ]; then
    echo "更新umask..."
    umask ${UMASK}
fi

# 创建工作空间
if [ ! -d "${WORK_SPACE}" ];then
    echo "生成工作空间目录 ${WORK_SPACE} ..."
    mkdir -p ${WORK_SPACE}
fi
chown -R ipex:ipex ${WORK_SPACE}

# 设置OPEN WEBUI参数
export DATA_DIR="${WORK_SPACE}/data"

source ipex-llm-init --gpu --device $DEVICE

# Ollama内核
ollama() {
    export OLLAMA_NUM_GPU=999
    export ZES_ENABLE_SYSMAN=1
    export OLLAMA_MODELS="${WORK_SPACE}/models"
    cd /llm/ollama
    /llm/ollama/ollama serve
}

# 启动 OpenWebUI
openwebui() {
    cd /llm/open-webui/backend
    bash start.sh
}



ollama &
openwebui &

wait