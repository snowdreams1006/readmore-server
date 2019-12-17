# readmore-server 

## 安装

### Docker 用户

![Docker Automated build](https://img.shields.io/docker/automated/snowdreams1006/readmore-server.svg) 
![MicroBadger Size](https://img.shields.io/microbadger/image-size/snowdreams1006/readmore-server.svg) 
![MicroBadger Layers](https://img.shields.io/microbadger/layers/snowdreams1006/readmore-server.svg)

- docker 

```shell script
docker run -d --name readmore -p 8080:8080 snowdreams1006/readmore-server
```

- docker-compose

``` sh
mkdir readmore-server && cd readmore-server
curl -sL https://raw.githubusercontent.com/snowdreams1006/readmore-server/master/docker-compose.yaml > docker-compose.yaml
docker-compose up -d
```

### 普通用户

1. 根据平台下载可执行文件,见[下载页面](https://github.com/snowdreams1006/readmore-server/releases) page
2. 赋予二进制命令可执行权限 : `chmod +x readmore-server`
3. 启动服务器 : `./Bark_linux_amd64 -l 0.0.0.0 -p 8080`
4. 测试服务器 : `curl localhost:8080/ping`

> Ping成功后，在APP端填入你的服务器IP或域名

## 参与贡献

### 开发环境

项目至少要求 `golang 1.12` 编译并且要求 `go module` 支持.

- Golang 1.13
- GoLand 2018.3.4 or other Go IDE
- Docker(Optional)

### 编写 web 服务

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
	http.ListenAndServe(":8080",nil)
}
```

- 在**当前目录**下打开终端,输入 `go run main.go` 命令启动本地服务

```go
go run main.go
```

除了直接启动服务之外,还可以输入 `go build -o readmore-server main.go` 在当前目录下生成可执行文件,后续运行 `./readmore-server` 命令即可启动本地服务.

- 在**任意目录**下打开终端,输入 `curl localhost:8080` 命令测试本地服务

```shell script
curl localhost:8080
```

或者打开浏览器直接访问 `localhost` 网址也会得到 `Welcome to readmore.snowdreams1006.cn!` 的响应.

- 如需停止本地服务,在上一步启动项目的终端同时按住 `Ctrl + C` 即可停止.

### 构建本地镜像

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

- 在**任意目录**下打开终端,输入 `curl localhost:8080` 命令测试本地服务

```shell script
curl localhost:8080
```

或者打开浏览器直接访问 `localhost:8080` 网址也会得到 `Welcome to readmore.snowdreams1006.cn!` 响应.

-  如需停止本地服务,在上一步启动项目的终端输入 `docker stop readmore-server` 命令即可停止容器.

```shell script
docker stop readmore-server
```

### 发布本地镜像

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

### 优化镜像

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
docker run --rm -d --name readmore-server -p 8080:8080 YOURUSERNAME/readmore-server:v0.0.2
```

`docker run --rm -d --name readmore-server -p 8080:8080 snowdreams1006/readmore-server:v0.0.2` 瞬间从之前的近 `400Mb` 精简到现在的 `10Mb` 左右,不可谓不成功!

### 自动构建

- `main.go` 文件增加日志输出

```go
package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	go func() {
		for {
			time.Sleep(time.Second)
			log.Println("Checking if started ...")
			resp, err := http.Get("http://localhost:8080")
			if err != nil {
				log.Println("Failed: ", err)
				continue
			}
			resp.Body.Close()
			if resp.StatusCode != http.StatusOK {
				log.Println("Not OK:", resp.StatusCode)
				continue
			}
			break
		}
		log.Println("Server is up and running , http://localhost:8080")
	}()

	log.Println("Starting server ...")
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Welcome to readmore.snowdreams1006.cn! \n")
	})
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("readmore-server started failed: ", err)
	}
}
```

- `Dockerfile` 文件增加作者信息

```dockerfile
FROM golang:1.13.1-alpine3.10 AS builder

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go install

FROM alpine:3.10

LABEL maintainer="snowdreams1006 <snowdreams1006@163.com>"

COPY --from=builder /go/bin/readmore-server /usr/local/bin/readmore-server

EXPOSE 8080

CMD readmore-server
```

- 配置自动构建

### 打包发布

- docker-compose

```yaml
version: '3.7'
services:
  bark-server:
    image: snowdreams1006/readmore-server
    container_name: readmore-server
    restart: always
    ports:
      - "8080:8080"
```

- Makefile

```makefile
BUILD_VERSION   := $(shell cat version)

all:
	gox -osarch="darwin/amd64 linux/386 linux/amd64" \
        -output="dist/{{.Dir}}_{{.OS}}_{{.Arch}}" \
    	-ldflags "-w -s"

docker:
	docker build -t snowdreams1006/readmore-server:${BUILD_VERSION} .

clean:
	rm -rf dist

install:
	go install

.PHONY : all release docker clean install
```

- go mod

```shell script
go mod init
```

```makefile
BUILD_VERSION   := $(shell cat version)

all:
	gox -osarch="darwin/amd64 linux/386 linux/amd64" \
        -output="dist/{{.Dir}}_{{.OS}}_{{.Arch}}" \
    	-ldflags "-w -s"

docker:
	docker build -t snowdreams1006/readmore-server:${BUILD_VERSION} .

clean:
	rm -rf dist

install:
	go install

.PHONY : all release docker clean install

.EXPORT_ALL_VARIABLES:

GO111MODULE = on
GOPROXY = https://goproxy.io
GOSUMDB = sum.golang.google.cn
```

```dockerfile
FROM golang:1.13.1-alpine3.10 AS builder

ENV GO111MODULE on
ENV GOPROXY https://goproxy.io
ENV GOSUMDB sum.golang.google.cn

COPY . /go/src/github.com/snowdreams1006/readmore-server

WORKDIR /go/src/github.com/snowdreams1006/readmore-server

RUN go install

FROM alpine:3.10

LABEL maintainer="snowdreams1006 <snowdreams1006@163.com>"

RUN apk upgrade \
    && apk add ca-certificates

COPY --from=builder /go/bin/readmore-server /usr/local/bin/readmore-server

EXPOSE 8080

CMD ["readmore-server"]
```

### docker 常用命令

删除未命名的进行

```shell script
docker rmi $(docker images | grep '<none>' | awk '{print $3}')
```

```shell script
docker rmi $(docker images -f "dangling=true" -q)
```

### 阅读更多

- 在线生成 `.gitignore` 忽略文件 [http://gitignore.io/](http://gitignore.io/)
- [如何快速正确使用Docker部署Go Web App](https://www.jianshu.com/p/b66af29452e7)
- [基于Docker和Golang搭建Web服务器](https://www.cnblogs.com/foxy/p/9274329.html)
- [使用Github自动构建Docker](https://www.jianshu.com/p/b20bcfba52a8)
- [golang http.ListenAndServe 阻塞导致if else不执行问题分析](http://blog.yoqi.me/lyq/16889.html)
- [10分钟学会go module](https://blog.csdn.net/e421083458/article/details/89762113)
- [docker 批量删除无用的容器或镜像](https://blog.csdn.net/qq_36961530/article/details/79554964)
- [Docker 删除所有无名称的镜像（悬空镜像）](https://www.cnblogs.com/stulzq/p/8962388.html)
