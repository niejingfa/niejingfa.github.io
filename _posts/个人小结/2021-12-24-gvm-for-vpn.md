---
layout: post
title:  "VPN 安装 gvm"
date:   2021-12-24 17:47:22 +0800
categories:
---
### 1. 背景
有是买了代理，但是 git clone 还是很慢，感觉好像没能用上代理，这是因为 git  git命令并不会直接走全局代理，需要通过git config配置：
- 千万别急，刚开始而已
- socks5协议，1080端口修改成自己的本地代理端口

### 2. git 配置代理
```shell
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# http协议，1081端口修改成自己的本地代理端口
git config --global http.proxy http://127.0.0.1:41091
git config --global https.proxy https://127.0.0.1:41091
```
这里的端口就是买的代理的端口，可以在 代理的配置里查看。



### 3. 查看所有配置
```shell
git config -l
```
### 4. reset 代理设置
```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### 5. 安装 GVM
```shell
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
```
或者将sh 文件在控制台下执行一下。