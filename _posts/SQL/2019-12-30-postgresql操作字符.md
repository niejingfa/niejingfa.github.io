---
layout: post
title:  "postgres 操作字符"
date:   2019-12-30 09:36:24 +0800
categories:
---

## `text`

- 把数据列转成字符串进行操作查询

- 例如： `cutoff_id::text`

## `substring`

- 切割字符串

- 例如： `substring(cutoff_id::text from 1 for 4)`

- **1: 哪个字符开始**

- **4: 截取几个字符**

- *_取 `cutoff_id` 的 第 1 个字符开始，取 4 个_*

## `lpad`

- 字符拼接

- 例如：`lpad(substring(cutoff_id::text, 10, '0')`

- **10: `cutoff_id` 要生成 10 位数**

- **'0': `cutoff_id` 少于 10 位，在左边补 '0'**

> 扩展阅读：*_rpad_*

## `char_length`

- 返回数据列的数据长度

- 例如：`char_length(cutoff_id::text)`

- 如果 `cutoff_id` 是 `2019101`, 返回 7

## `RIGHT`

- 从右边开始截取字符

- 例如： `RIGHT(cutoff_id::text, 1)`

- **1: 1 个字符**

- 返回 `cutoff_id` 最右边的 1 个字符

## `||`

- 合并字符串

- 例如： `substring(cutoff_id::text from 1 for 4)||RIGHT(cutoff_id::text, 1)`

- 如果：`cutoff_id` 为 `2019112`, 返回：'20192'