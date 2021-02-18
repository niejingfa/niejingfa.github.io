---
layout: post
title:  "Vue 3.0 之 composition-api"
date:   2020-12-13 16:57:22 +0800
categories:
---

### 前言
使用 `Composition API` 编写的代码更易读，并且场景不复杂，这使得阅读和学习变得更容易。

解决了 `vue 2.x` 选项式 API 的一些痛点：
- 基于 `Vue2` 的大型组件很难维护。
- 基于 `Vue2` 封装的组件逻辑复用困难。
- `Vue2` 对 `TypeScript` 支持有限。

一般我们的项目都是 `vue 2.x`, 如果想使用 `composition-api`
可以使用这个插件： [@vue/composition-api](https://github.com/vuejs/composition-api)

### 一、 引入到项目中
#### 1. 安装
```bash
npm install @vue/composition-api
# or
yarn add @vue/composition-api
```
#### 2. 配置

在 `main.js` 中添加一下配置：
```js
import Vue from 'vue'
import VueCompositionAPI from '@vue/composition-api'

Vue.use(VueCompositionAPI)
```

### 二、 使用
---
#### 1. reactive 和 ref
#### 1.1. reactive
接收一个普通对象然后返回该普通对象的响应式代理。

响应式转换是“深层的”：会影响对象内部所有嵌套的属性。基于 ES2015 的 Proxy 实现，返回的代理对象不等于原始对象。建议仅使用代理对象而避免依赖原始对象。
```vue
<template>
  <div>
    <span>{{ people.name }}</span>
    <br>
    <span>{{ people.age }}</span>
    <br>
    <button @click='addAge'>改变属性</button>
    <button @click='changePeople'>改变对象</button>
    <button @click='changeObject'>改变 reactive</button>
  </div>
</template>
<script>
// 导入 reactive
import { reactive } from '@vue/composition-api'

export default {
  // 代替之前的 beforeCreate, create
  setup () {
    let people = reactive({name: 'blank', age: 25})
    function addAge () {
      people.age ++
    }

    function changePeople () {
      people = { name: 'shawn', age: 21 }
      console.log(people)
    }

    function changeObject () {
      people = reactive({ name: 'jesse', age: 18 })
      console.log(people)
    }

    // 返回用到的方法和数据
    return { people, addAge, changePeople, changeObject }
  }
}
</script>
```

#### 1.2. ref
接受一个参数值并返回一个响应式且可改变的 `ref` 对象。ref 对象拥有一个指向内部值的单一属性 `.value`

如果传入 `ref` 的是一个对象，将调用 `reactive` 方法进行深层响应转换。

```vue
<template>
  <div>
    <!-- > age 默认不用加 value < -->
    <span>{{ age }}</span>
    <br>
    <button @click='addAge'>改变</button>
  </div>
</template>
<script>
import { ref } from '@vue/composition-api'

export default {
  setup () {
    let age = ref(25)
    function addAge () {
      // 需要 .value
      age.value ++
    }
    return { age, addAge }
  }
}
</script>
```

---

#### 2. watch
和 `vue2.x` 中的 `watch` 一样

```vue
<template>
  <div>
    <!-- > age 默认不用加 value < -->
    <span>{{ age }}</span>
    <br>
    <button @click='addAge'>改变</button>
  </div>
</template>
<script>
import { watch } from '@vue/composition-api'

export default {
  setup () {
    let age = ref(25)
    function addAge () {
      // 需要 .value
      age.value ++
    }
    watch(
      () => age.value,
      (to, from) => {
        alert(to);
      }
    )
    return { age, addAge }
  }
}
</script>

```
其他关键字如下：
```js
beforeCreate -> 使用 setup()
created -> 使用 setup()
beforeMount -> onBeforeMount
mounted -> onMounted
beforeUpdate -> onBeforeUpdate
updated -> onUpdated
beforeDestroy -> onBeforeUnmount
destroyed -> onUnmounted
errorCaptured -> onErrorCaptured
```
**注：`setup()` 中 `this` 不可用，是 `undefined`**

---
#### 3. setup 中传入的属性

- props
- context
  - root: `vue2.x` 中的 `this`
  - emit: `vue2.x` 中的 `this.$emit`
  - attrs: `vue2.x` 中的 `this.$attrs`
  - slots: `vue2.x` 中的 `this.$slots`

```vue
<script>
import { watch } from '@vue/composition-api'

export default {
  // props： 组件中传递的参数
  setup (props, context) {
    // this
    console.log(context.root)
    // this.$emit
    console.log(context.emit)
    // this.$attrs
    console.log(context.attrs)
    // this.$slots
    console.log(context.slots)
  }
}
</script>
```
---
#### 4. 依赖注入 provide 和 inject
`provide` 和 `inject` 提供依赖注入，功能类似 `2.x` 的 `provide/inject`。两者都只能在当前活动组件实例的 `setup()` 中调用

```vue
<template>
  <div>
    <span>{{ person }}</span>
    <button @click='addAge'>改变</button>
    <InjectVue />
  </div>
</template>
<script>
import { provide, reactive } from '@vue/composition-api'

import InjectVue from './inject.vue'

export default {
  setup () {
    let person = reactive({name: 'blank', age: 25})
    provide('person', person)

    function addAge () {
      person.age ++
    }

    return { person, addAge }
  },
  components: {
    InjectVue
  }
}
</script>
```

`inject.vue`
```vue
<template>
  <div>
    <span>inject: {{ person }}</span>
    <button @click='changePerson'>改变</button>
  </div>
</template>
<script>
import { inject } from '@vue/composition-api'

export default {
  setup () {
    let person = inject('person')

    function changePerson () {
      person = {name: 'shawn', age: 21}
      console.log(person)
    }

    return { person, changePerson }
  }
}
</script>
```

**可以使用 `ref` 来保证 `provided` 和 `injected` 之间值的响应**

## 参考文档：
> https://composition-api.vuejs.org/zh/api.html
<br>
https://github.com/vuejs/composition-api
<br>
https://v3.cn.vuejs.org/api/composition-api.html
