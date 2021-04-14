---
layout: post
title:  "vue-cli-service 的使用"
date:   2021-02-20 16:47:22 +0800
categories:
---
#### 1. 全局安装 vue-cli-service
```shell
npm install -g @vue/cli
# OR
yarn global add @vue/cli
```

#### 2. 问题
```shell
zsh: command not found: vue-cli-service
```
是因为vue-cli-service 并没有加入到环境变量里。
手动在命令行里手动加上

#### 3. 解决
```shell
# 添加vue-cli-service的环境变量
PATH=$PATH:./node_modules/.bin
 
#查看添加后的环境变量
echo $PATH
```

之后 vue-cli-service 命令就可以使用了。

但是这样仅在本次terminal有效，每次都添加一次也太麻烦了，我们需要永久添加：

```shell
# 编辑根目录下的.bash_profile文件
vim ~/.bash_profile
 
# 在文件最后添加
export PATH=${PATH}:./node_modules/.bin
 
# 添加文件后,再执行source立即生效，就可以永久保存啦
source ~/.bash_profile
```