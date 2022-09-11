FROM golang:1.19-alpine3.16 AS build-env
WORKDIR /go/src/app
RUN  /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories

ENV  GO111MODULE=on
ENV  GOPROXY=https://goproxy.cn
COPY . .
RUN apk update && apk add git \
    && go build -o app

FROM alpine:latest
WORKDIR /app
RUN  /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=build-env /go/src/app/app /app/app
EXPOSE 3000
CMD ["/app/app"]