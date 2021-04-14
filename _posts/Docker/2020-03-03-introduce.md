---
layout: post
title:  "Docker 介绍"
date:   2020-03-03 18:01:22 +0800
categories:
---

## 1. 为什么要用docker?

对开发和运维（devop）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。

有时候环境真的很难搭，网络原因，之前的包原因，各种版本的不兼容原因
> [详细](https://wiki.jikexueyuan.com/project/docker-technology-and-combat/why.html)

## 2. dockerfile 的配置

```dockerfile
# 定制的镜像都是基于 FROM 的镜像
FROM ruby:2.5.1-alpine3.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

# 改 apk 的镜像源
RUN echo 'http://mirrors.aliyun.com/alpine/edge/community' >> /etc/apk/repositories
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 安装一些要用到的系统包
RUN apk add --no-cache --virtual build-deps build-base postgresql-dev

WORKDIR /usr/src/app

COPY . .
RUN bundle install
```

查看容器列表

`docker ps -a`

通过容器 id 删除容器

`docker rm container`

查看镜像列表

`docker images`

通过镜像 id 删除镜像

`docker rmi image`

运行并进入容器

`docker run -it my_demo /bin/sh`

进入容器

`docker exec -it my_demo /bin/sh`

打包镜像

`docker build -t my_rails:latest .`

运行容器

`docker run --name my_rails -i -t -p 3000:3000 --network host  -v ~/Documents/:/var/www my_rails:latest /bin/sh`

-v ~/webs/:/var/www，这个参数的作用是将外部的文件夹~/webs映射到容器内/var/www中，在容器内可以共享外面的文件（代码）了。

## 3. 招内 docker
```
FROM ruby:2.1.4
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
EXPOSE 3000
EXPOSE 3306
WORKDIR /usr/src/app
COPY . .
RUN gem install highline -v '1.6.21'
RUN bundle
```

```powershell
docker build -t bid-ms:latest .
```

```powershell
docker run --name bid-ms -i -t -p 3000:3000 --network host  -v ~/Documents/:/var/www bid-ms:latest /bin/bash
```

`mac` 链接本地的服务

`localhost => host.docker.internal`

`linux` 链接本地的服务 `127.0.0.1`

## 4. 想搜索一下有哪些 tags

这是 shell 脚本：
```bash
#!/bin/bash

if [ $# -lt 1 ]
then
cat << HELP

dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE: 
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache

HELP
fi

image="$1"
tags=`wget -q https://registry.hub.docker.com/v1/repositories/${image}/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'`

if [ -n "$2" ]
then
    tags=` echo "${tags}" | grep "$2" `
fi

echo "${tags}"
```

命名为 `dockertags`, 把路劲放在 `~/.zshrc` 或者 `~/.bashrc`下： `alias dockertags='${path}'`

可以使用 `dockertags ruby` 可以查看 `ruby` 所有的 `tags`

具体的 `ruby tags` 可以在[这里](https://hub.docker.com/_/ruby?tab=tags)查看

### 5.扩展
> 1. http://in4.rccchina.com/doc/index.html#/doc/d864855f
> 2. docker-compose 编排
