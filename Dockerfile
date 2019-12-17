FROM golang:1.13.1-alpine3.10 AS builder

ENV GO111MODULE on
ENV GOPROXY https://goproxy.io
ENV GOSUMDB sum.golang.google.cn

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go install

FROM alpine:3.10

LABEL maintainer="snowdreams1006 <snowdreams1006@163.com>"

COPY --from=builder /go/bin/readmore-server /usr/local/bin/readmore-server

EXPOSE 8080

CMD ["readmore-server"]
