FROM alpine:latest

RUN apk --no-cache add curl

WORKDIR /app

COPY . /app

# CMD ["sh", "-c", "sh /app/main.sh > /app/work/log/kroki-client.log 2>&1"]
CMD ["sh", "-c", "sh /app/main.sh > /app/work/log/kroki-client.log 2>&1 && exec sleep infinity"]

# CMD ["sh", "-c", "sh /app/show_config.sh > /app/work/log/kroki-client.log 2>&1"]
