FROM golang:1.13.1-alpine3.10 AS builder

RUN mkdir -p /go/src/github.com/snowdreams1006/readmore-server

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go build -o readmore-server main.go

FROM alpine:3.10

COPY --from=builder /go/src/github.com/snowdreams1006/readmore-server/readmore-server /usr/local/bin/readmore-server

CMD readmore-server
