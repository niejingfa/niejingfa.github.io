---
layout: post
title:  "在国内快速更新debian和alpine"
date:   2017-07-01 13:55:52 +0800
categories: linux tips
---

### 开源镜像站

* [国内开源镜像站点汇总](https://segmentfault.com/a/1190000000375848)
* [USTC Mirror Help](https://mirrors.ustc.edu.cn/help/)

### debian

* [第 6 章 维护和更新：APT 工具](https://debian-handbook.info/browse/zh-CN/stable/apt.html#sect.apt-sources.list)


**如何替换**

	sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list


* `deb.debian.org`: `Debian 软件源`
* `security.debian.org`:`Debian 软件安全更新源`

**使用https协议(可选)**

使用 HTTPS 可以有效避免国内运营商的缓存劫持，但需要事先安装 apt-transport-https

	apt-get install -yq apt-transport-https ca-certificates
	sed -i 's/http/https/g' /etc/apt/sources.list


### alpine

[Alpine packages](https://pkgs.alpinelinux.org/packages) / [Edge - Alpine Linux](https://wiki.alpinelinux.org/wiki/Edge)

**如何替换**

	echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' | tee -a /etc/apk/repositories
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
