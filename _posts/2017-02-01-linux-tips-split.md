---
layout: post
title:  "文件数据源处理杂谈"
date:   2017-02-01 17:43:52 +0800
categories: linux tips
---

由于某种未知的原因采集 `某政务公开系统` 的数据以
`deploy.json`(源: MongoDB)交付，为方便其他程序处理需要拆分为小文件。


### 已经遇到问题

主机在 Aliyun 文件上传时挂载了`100G`的盘，分割时遇到空间不足添加一块 `500G` 盘

* 查看硬盘列表: `fdisk -l`
* 分区: `fdisk /dev/vdc`
* 格式化: `mkfs.ext3 /dev/vdc1`
* 修改fstab: `/dev/vdc1 /media/data ext3 defaults 0 0`
* 挂载: `mount -a`

### 处理流程

1. 计算文件容量(64G): `du -h deploy.json`
2. 计算数据量(9,744,440/14m): `wc -l deploy.json`
3. 分割文件(0 ~ 194): `split -50000 -d -a 6 deploy.json deploy_`

### 后期将遇到的问题

* 应用程序，数据源分布在不同机器处理困难
* 数据安全难以保证(泄密，丢失, 篡改)

###  处理方案

* 在客户端把文件拆分为小文件(同时提供提供Hash值)
* 文件存储到第三方存储
* 为应用程序提供测试数据


### 分割相关资料

`split` 命令可以将一个大文件分割成很多个小文件。

    split [OPTION]... [INPUT [PREFIX]]

**选项**

  * `-<num>`: 按行数分割
  * `-b <size>`: 按容量分割
  * `-d`: 使用数字作为后缀
  * `-a <length>`: 指定后缀的长度
