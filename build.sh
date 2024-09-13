# docker build --no-cache -t kroki-client .

TAG=$(date +%s)
docker build --no-cache . --file Dockerfile --tag luizgsbraz/kroki-client:$TAG
docker tag luizgsbraz/kroki-client:$TAG luizgsbraz/kroki-client:latest
