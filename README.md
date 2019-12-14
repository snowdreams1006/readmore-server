# readmore-server 

## 编写 web 服务

- 在**当前目录**新建 `main.go` 文件且文件内容如下:

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

- 在**当前目录**下打开终端,输入 `go run main.go` 命令启动本地服务

```go
go run main.go
```

除了直接启动服务之外,还可以输入 `go build -o readmore-server main.go` 在当前目录下生成可执行文件,后续运行 `./readmore-server` 命令即可启动本地服务.

- 在**任意目录**下打开终端,输入 `curl localhost` 命令测试本地服务

```shell script
curl localhost
```

或者打开浏览器直接访问 `localhost` 网址也会得到 `Welcome to readmore.snowdreams1006.cn!` 的响应.

- 如需停止本地服务,在上一步启动项目的终端同时按住 `Ctrl + C` 即可停止.

## 构建本地镜像

- 在**当前目录**下新建 `Dockerfile` 文件且文件内容如下:

```dockerfile
FROM golang:1.13.1-alpine3.10

RUN mkdir -p /go/src/github.com/snowdreams1006/readmore-server

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go build -o readmore-server main.go

CMD /go/src/github.com/snowdreams1006/readmore-server/readmore-server
```

- 在**当前目录**下打开终端,输入 `docker build -t snowdreams1006/readmore-server:v0.0.1 .` 命令构建本地镜像

```shell script
docker build -t YOURUSERNAME/readmore-server:v0.0.1 .
```

> 请确保本地已安装 `docker` 环境,如果输入 `docker` 命令提示 `-bash: docker: command not found` 则表示未安装 `docker` 环境,请参考[docker-for-mac](https://docs.docker.com/docker-for-mac/install/)完成安装.

- 在**任意目录**下打开终端,输入 `docker run --rm -d --name readmore-server -p 80:80 snowdreams1006/readmore-server:v0.0.1` 命令测试本地镜像

```shell script
docker run --rm -d --name readmore-server -p 80:80 YOURUSERNAME/readmore-server:v0.0.1
```

- 在**任意目录**下打开终端,输入 `curl localhost` 命令测试本地服务

```shell script
curl localhost
```

或者打开浏览器直接访问 `localhost` 网址也会得到 `Welcome to readmore.snowdreams1006.cn!` 响应.

-  如需停止本地服务,在上一步启动项目的终端输入 `docker stop readmore-server` 命令即可停止容器.

```shell script
docker stop readmore-server
```

## 发布本地镜像

- 登录 dockerhub

```shell script
docker login
```

- 推送镜像

> docker push snowdreams1006/readmore-server:v0.0.1

```shell script
docker push YOURUSERNAME/readmore-server:v0.0.1
```

- 搜索镜像

```shell script
docker search readmore-server
```

或者打开 `dockerhub` 网站直接搜索 `readmore-server` 验证是否发布成功,[体验地址](https://hub.docker.com/r/snowdreams1006/readmore-server)

## 优化镜像

### 精简镜像大小

实际发现运行 `docker pull snowdreams1006/readmore-server:v0.0.1` 命令下载镜像的文件大小将近 `400Mb` ,毕竟只是一个简单的 `Web` 服务不能这么大,因此需要优化一下.

- 增加精简版 `alpine` 镜像

```dockerfile
FROM golang:1.13.1-alpine3.10 AS builder

RUN mkdir -p /go/src/github.com/snowdreams1006/readmore-server

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go build -o readmore-server main.go

FROM alpine:3.10

COPY --from=builder /go/src/github.com/snowdreams1006/readmore-server/readmore-server /usr/local/bin/readmore-server

CMD readmore-server
```

- 再次构建

```shell script
docker build -t YOURUSERNAME/readmore-server:v0.0.2 .
```

- 再次推送

```shell script
docker push YOURUSERNAME/readmore-server:v0.0.2
```

- 再次体验

```shell script
docker run --rm -d --name readmore-server -p 80:80 YOURUSERNAME/readmore-server:v0.0.2
```

`docker run --rm -d --name readmore-server -p 8989:80 snowdreams1006/readmore-server:v0.0.2` 瞬间从之前的近 `400Mb` 精简到现在的 `10Mb` 左右,不可谓不成功!

## 阅读更多

- 在线生成 `.gitignore` 忽略文件 [http://gitignore.io/](http://gitignore.io/)
- [如何快速正确使用Docker部署Go Web App](https://www.jianshu.com/p/b66af29452e7)
- [基于Docker和Golang搭建Web服务器](https://www.cnblogs.com/foxy/p/9274329.html)
