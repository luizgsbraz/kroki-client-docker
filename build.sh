# $CONTAINER_TOOL build --no-cache -t kroki-client .
# Verifica se o Podman está disponível, caso contrário, usa Docker
if command -v podman &> /dev/null
then
    export CONTAINER_TOOL="podman"
else
    export CONTAINER_TOOL="docker"
fi

TAG=$(date +%s)
$CONTAINER_TOOL build --no-cache . --file Dockerfile --tag luizgsbraz/kroki-client:$TAG
$CONTAINER_TOOL tag luizgsbraz/kroki-client:$TAG luizgsbraz/kroki-client:latest
