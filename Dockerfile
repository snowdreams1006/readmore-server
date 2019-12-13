FROM alpine:latest #使用了镜像大小体积只有5MB的alpine镜像

WORKDIR / #设置工作路径

ADD readmore / #把上文编译好的main文件添加到镜像里

EXPOSE 3000 #暴露容器内部端口

ENTRYPOINT ["./readmore"] #入口
