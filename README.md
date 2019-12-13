# readmore-server 

## 编写 web 服务

1. 在**当前目录**新建 `main.go` 文件且文件内容如下:

```go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Welcome to readmore.snowdreams1006.cn! \n")
	})
	http.ListenAndServe(":80",nil)
}
```

2. 在**当前目录**下打开终端,输入 `go run main.go` 命令启动本地服务

```go
go run main.go
```

除了直接启动服务之外,还可以输入 `go build -o readmore main.go` 在当前目录下生成可执行文件,后续执行 `./readmore` 启动本地服务.

3. 在**任意目录**下打开终端,输入 `curl localhost:3000` 命令测试本地服务

```shell script
curl localhost:3000
```

或者打开浏览器直接访问 `localhost:3000` 网址也会得到 `Hello World` 响应.

## 构建本地镜像

# build the server

1. 在**当前目录**下新建 `Dockerfile` 文件且文件内容如下:

```dockerfile
FROM golang:1.13.1-alpine3.10 AS builder

RUN mkdir -p /go/src/github.com/snowdreams1006/readmore-server

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go build -o readmore-server main.go

CMD /go/src/github.com/snowdreams1006/readmore-server
```

2. 在**当前目录**下打开终端,输入 `docker build -t readmore .` 命令构建本地镜像

```shell script
docker build -t readmore .
```

> 请确保本地已安装 `docker` 环境,如果输入 `docker` 命令提示 `-bash: docker: command not found` 则表示未安装 `docker` 环境,请参考[]()完成安装.

3. 在**任意目录**下打开终端,输入 `docker run --rm -it -d -p 3000:3000 readmore` 命令测试本地镜像

```shell script
docker run --rm -it -d -p 3000:3000 readmore
```

4. 在**任意目录**下打开终端,输入 `curl localhost:3000` 命令测试本地服务

```shell script
curl localhost:3000
```

或者打开浏览器直接访问 `localhost:3000` 网址也会得到 `Hello World` 响应.

## 阅读更多

- 在线生成 `.gitignore` 忽略文件 [http://gitignore.io/](http://gitignore.io/)
- [如何快速正确使用Docker部署Go Web App](https://www.jianshu.com/p/b66af29452e7)
- [基于Docker和Golang搭建Web服务器](https://www.cnblogs.com/foxy/p/9274329.html)
