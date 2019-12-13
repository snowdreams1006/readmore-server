# readmore-server

## 编写 web 服务

1. 在**当前目录**新建 `main.go` 文件且文件内容如下:

```go
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		fmt.Fprint(writer, "Hello World")
	})
	log.Fatal(http.ListenAndServe(":3000",nil))
}
```

2. 在**当前目录**下打开终端,输入 `go run main.go` 命令启动本地服务

```go
go run main.go
```

3. 在**任意目录**下打开终端,输入 `curl localhost:3000` 命令测试本地服务

```shell script
curl localhost:3000
```

或者打开浏览器直接访问 `localhost:3000` 网址也会得到 `Hello World` 响应.

## 编写 Dockerfile

1. 在**当前目录**下新建 `Dockerfile` 文件且文件内容如下:

```shell script
FROM alpine:latest #使用了镜像大小体积只有5MB的alpine镜像

WORKDIR / #设置工作路径

ADD main / #把上文编译好的main文件添加到镜像里

EXPOSE 3000 #暴露容器内部端口

ENTRYPOINT ["./main"] #入口
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
