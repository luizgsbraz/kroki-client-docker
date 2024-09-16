prod=false
deploy=false

usage() {
    echo "Usage: $0 [-prod] [-deploy]" 1>&2
    echo "  -prod: Build the image for production" 1>&2
    echo "  -deploy: Deploy the image to Docker Hub" 1>&2
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -help) usage ;;
        -prod) prod=true ;;
        -deploy) deploy=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

image_name="luizgsbraz/kroki-client"

if command -v podman &> /dev/null
then
    export CONTAINER_TOOL="podman"
else
    export CONTAINER_TOOL="docker"
fi

RELEASE_NUM=$(date +%s)

TAG="testing"
if [ "$prod" = true ]
then
    TAG="latest"
fi

$CONTAINER_TOOL build --no-cache . --file Dockerfile --tag $image_name:$RELEASE_NUM
$CONTAINER_TOOL tag $image_name:$RELEASE_NUM $image_name:$TAG
$CONTAINER_TOOL rmi $image_name:$RELEASE_NUM   

if [ "$deploy" = true ]
then
    $CONTAINER_TOOL login docker.io
    $CONTAINER_TOOL push $image_name:$TAG
else
    echo "To deploy the image, run the following commands:"
    echo "$CONTAINER_TOOL login docker.io"
    echo "$CONTAINER_TOOL push $image_name:$TAG"
fi

