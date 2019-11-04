---
layout: post
title:  "Rails 删除小结"
date:   2019-10-16 17:47:22 +0800
categories:
---

### 1. 沙盒(`sandbox`)模式
* 可用沙盒模式进行测试，`rails c --sandbox` {% highlight ruby %}
    # Any modifications you make will be rolled back on exit{% endhighlight ruby %}
* `sandbox` 模式，会模拟 增删改 数据以及关联关系，并不会提交事务，所以不会插入到库， 所有的操作都会在退出的时候 `rollback`

### 2. `delete_all`
* `delete_all` 不会走 `callback`, 会直接生成一条 `delete SQL` 语句，比如：
{% highlight ruby %} Project.where(id: 1).delete_all
# =>
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 1]]
{% endhighlight ruby %}

### 3. `destroy_all`
* `destroy_all` 会走 `callback`（相关的数据也都删除）, 会生成多条 `delete SQL` 语句
{% highlight ruby %}
Project.where(id: [1, 2]).destroy_all
# =>
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 1]]
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 2]]
{% endhighlight ruby %}

* 同时也会把模型中 `has_many` 配置了 `dependent: :delete_all` 或者 `dependent: :destroy` 的给删除掉

#### 3.1. `destroy_all` 之 `has_many` 中的参数 `dependent: :delete_all`
  * `dependent: :delete_all` 会生成一条 `delete SQL` 语句, `has_many` 关系数据全部删除, `has_many`关联的模型不会走 `callback`
{% highlight ruby %}
Project.where(id: [1, 2]).destroy_all
# =>
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 1]]
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."PROJECT_ID" = :a1  [["project_id", 1]]
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 2]]
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."PROJECT_ID" = :a1  [["project_id", 2]]
{% endhighlight ruby %}

#### 3.2. `destroy_all` 之 `has_many` 中的参数 `dependent: :destroy_all`

  * `dependent: :destroy` 会生成多条 `delete SQL` 语句, `has_many` 全部删除, 会走 `callback`（相关的数据也都删除）
{% highlight ruby %}
Project.where(id: [1, 2]).destroy_all
# =>
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 1]]
# 多条
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."ID" = :a1  [["id", 1804]]
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."ID" = :a1  [["id", 1803]]
# DELETE FROM "PROJECTS" WHERE "PROJECTS"."ID" = :a1  [["id", 2]]
# 多条
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."ID" = :a1  [["id", 1806]]
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."ID" = :a1  [["id", 1805]]
{% endhighlight ruby %}

### 4. **特别注意：`has_many.delete_all`**
{% highlight ruby %}
`Project.find(1).project_extra_properties.delete_all`, 并不一定会生成一条 `delete SQL` 语句
{% endhighlight ruby %}

#### 4.1. **如果你的 `has_many` 配置了 `dependent` 参数 `dependent: :destroy` 或者 `dependent: :delete_all`**
会生成一条 `delete SQL` 语句
{% highlight ruby %}
# DELETE FROM "PROJECT_EXTRA_PROPERTIES" WHERE "PROJECT_EXTRA_PROPERTIES"."PROJECT_ID" = :a1  [["project_id", 1]]
{% endhighlight ruby %}

#### 4.2. **如果你的 `has_many` 没有配置 `dependent: :destroy` 或者 `dependent: :delete_all`**
- #### 而是会生成一条 `update` SQL 语句
{% highlight ruby %}
#  UPDATE "PROJECT_EXTRA_PROPERTIES" SET "PROJECT_EXTRA_PROPERTIES"."PROJECT_ID" = NULL WHERE "PROJECT_EXTRA_PROPERTIES"."PROJECT_ID" = :a1  [["project_id", 1]]
{% endhighlight ruby %}

<hr>
<br>
{% highlight ruby %}
# select * from projects where project_name = NULL
# select * from projects where project_name is NULL
{% endhighlight ruby %}

以上两条语句查询出的结果不一样
`project_name = NULL` 永远不会为 `true`

用 `project_name is NULL` 代替 

