# Vue 3.0 之 composition-api

## 前言
1. 使用 `Composition API` 编写的代码更易读，并且场景不复杂，这使得阅读和学习变得更容易。
2. 解决了 `vue 2.x` 选项式 API 的一些痛点：

- 基于 `Vue2` 的大型组件很难维护。
- 基于 `Vue2` 封装的组件逻辑复用困难。
- `Vue2` 对 `TypeScript` 支持有限。

一般我们的项目都是 `vue 2.x`, 如果想使用 `composition-api`
可以使用这个插件 [@vue/composition-api](https://github.com/vuejs/composition-api)

## 1. 引入到项目中
- 安装
```bash
npm install @vue/composition-api
# or
yarn add @vue/composition-api
```
- 配置

在 `main.js` 中添加一下配置：
```js
import Vue from 'vue'
import VueCompositionAPI from '@vue/composition-api'

Vue.use(VueCompositionAPI)
```

## 2. 使用




## 参考文档：
> https://composition-api.vuejs.org/zh/api.html
<br>
https://github.com/vuejs/composition-api
<br>
https://v3.cn.vuejs.org/api/composition-api.html