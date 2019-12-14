FROM golang:1.13.1-alpine3.10

RUN mkdir -p /go/src/github.com/snowdreams1006/readmore-server

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go build -o readmore-server main.go

CMD /go/src/github.com/snowdreams1006/readmore-server/readmore-server
