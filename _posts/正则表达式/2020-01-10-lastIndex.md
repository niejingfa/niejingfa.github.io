---
layout: post
title: "RegExp.lastIndex 属性"
date:   2020-01-10 18:10:22 +0800
categories:
---
# `RegExp.lastIndex` 属性

遇到一个[售后](http://jira.rccchina.com/browse/PG-2081) ，
`Regexp` 匹配数据时，有时候数据能匹配出来，有时候不能匹配出来

总结了一下 `Regexp` 的问题

- 代码示例如下：
```js
let reg = new RegExp('c.*', 'g')

reg.test('chen') // true
reg.test('chen') // false

```

同样两次比对，第一次返回 true， 第二次返回 false

- 查找原因

查阅资料后发现，是正则的 `lastIndex` 改变了

```js
let reg = new RegExp('c.*', 'g')
console.log(reg.lastIndex) // 0

reg.test('chen') // true
console.log(reg.lastIndex) // 4

reg.test('chen') // false
console.log(reg.lastIndex) // 0
```

> 只有正则表达式使用了表示全局检索的 "g" 标志时，该属性才会起作用。此时应用下面的规则：\
如果 lastIndex 大于字符串的长度，则 regexp.test 和 regexp.exec 将会匹配失败，然后 lastIndex 被设置为 0。\
如果 lastIndex 等于字符串的长度，且该正则表达式匹配空字符串，则该正则表达式匹配从 lastIndex 开始的字符串。（then the regular expression matches input starting at lastIndex.）\
如果 lastIndex 等于字符串的长度，且该正则表达式不匹配空字符串 ，则该正则表达式不匹配字符串，lastIndex 被设置为 0.。\
否则，lastIndex 被设置为紧随最近一次成功匹配的下一个位置。