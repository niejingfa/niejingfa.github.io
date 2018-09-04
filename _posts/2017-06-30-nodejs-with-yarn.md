---
layout: post
title:  "Node.js & Yarn安装"
date:   2017-06-30 17:43:52 +0800
categories: linux tips
---

本教程讲述如何安装 [Node.js][Node.js](同时安装多版本请使用 [nvm][nvm]) 与 [Yarn][Yarn]

## Nodejs


**自动安装(开发推荐)**

	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	sudo apt-get install -y nodejs

**手动安装**

	# Add the NodeSource package signing key
	curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

	# 官方仓库
	echo "deb https://deb.nodesource.com/node_6.x xenial main" | sudo tee /etc/apt/sources.list.d/nodesource.list

	# 清华大学开源软件镜像站(速度快)
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_6.x xenial main" | sudo tee /etc/apt/sources.list.d/nodesource.list

	sudo apt-get install apt-transport-https
	sudo apt-get update
	sudo apt-get install nodejs


### Yarn

**安装**

	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

	sudo apt-get update && sudo apt-get install yarn



**参考资料**

* [Installing Node.js via package manager](https://nodejs.org/en/download/package-manager/)
* [nodesource/distributions](https://github.com/nodesource/distributions)
* [Nodesource 镜像使用帮助](https://mirror.tuna.tsinghua.edu.cn/help/nodesource/)

[Node.js]: https://nodejs.org/en/
[nvm]: https://github.com/creationix/nvm
[Yarn]: https://yarnpkg.com/zh-Hans/
