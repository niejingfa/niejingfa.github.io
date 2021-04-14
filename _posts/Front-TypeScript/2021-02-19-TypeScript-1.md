---
layout: post
title:  "TypeScript 简介"
date:   2021-02-19 09:52:22 +0800
categories:
---
### 前言
TypeScript 是 JavaScript 的一个超集，支持 ECMAScript 6 标准<br>
TypeScript 由微软开发的自由和开源的编程语言。<br>
TypeScript 设计目标是开发大型应用，它可以编译成纯 JavaScript，编译出来的 JavaScript 可以运行在任何浏览器上。

### 安装
#### NPM 安装 TypeScript
```shell
npm install -g typescript
```

#### YARN 安装 TypeScript
```shell
yarn global add typescript
```
---
安装成之后，我们就可以通过 `tsc` 命令来执行 `TypeScript` 相关代码，以下是查看版本号：
```shell
$ tsc -v
Version 4.1.5
```
也可以通过 `tsc` 命令来编译 `ts` 代码：<br>
`ts` 代码如下：
```js
// typescript-example.ts
var message:string = "Hello World" 
console.log(message)
```
执行 `tsc typescript-example.ts`，生成 .js 文件
```js
// typescript-example.js
var message = "Hello World";
console.log(message);
```

### 更多 TypeScript 语法
...