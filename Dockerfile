FROM alpine:latest

RUN apk --no-cache add curl

WORKDIR /app

RUN mkdir -p /app/work/log
RUN mkdir -p /app/work/in
RUN mkdir -p /app/work/out

COPY . /app

# CMD ["sh", "-c", "sh /app/main.sh > /app/work/log/kroki-client.log 2>&1"]
CMD ["sh", "-c", "sh /app/main.sh > /app/work/log/kroki-client.log 2>&1 && exec sleep infinity"]

# CMD ["sh", "-c", "sh /app/show_config.sh > /app/work/log/kroki-client.log 2>&1"]
