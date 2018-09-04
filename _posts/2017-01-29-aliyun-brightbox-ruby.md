---
layout: post
title:  "Aliyun Ubuntu Install Brightbox Ruby"
date:   2017-01-29 13:38:52 +0800
categories: ubuntu ruby
---
在阿里云 Ubuntu 上安装 [Brightbox Ruby][Brightbox] 遇到 `403  Forbidden`错误。
因为系统设置了默认的`APT代理` 为 `http://mirrors.aliyun.com/` 以加快安装速度，但是
不能解决`ppa.launchpad.net`。可使用如下命令解决问题

方案1: 关闭代理

    sudo sed -i 's/\(^Acquire::http::Proxy\)/# \1/' /etc/apt/apt.conf

方案2: ppa.launchpad.net 不使用代理

    echo "Acquire::http::Proxy::ppa.launchpad.net DIRECT;" | sudo tee -a /etc/apt/apt.conf

####  相关资料
配置文件

    /etc/apt/apt.conf
    /etc/apt/apt.conf.d/

命令行

    apt-get -o

**参数**

1. `Acquire::http::Proxy "http://[[user][:pass]@]host[:port]/";`
2. `Acquire::https::proxy "http://[[user][:pass]@]host[:port]/";`
3. `Acquire::http::Proxy::<host> DIRECT;`
4. `Debug::Acquire::http`
5. `Debug::Acquire::https`

[Brightbox]: https://www.brightbox.com/docs/ruby/ubuntu/
