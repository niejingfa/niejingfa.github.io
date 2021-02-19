---
layout: post
title:  "SQL 批量插入"
date:   2020-02-02 11:30:22 +0800
categories:
---
新建一张简单的表
```ruby
create_table :blank_tests do |t|
  t.integer :test_id, index: true
  t.string :test_text, limit: 50
end
```
## 1. create(Array)
```ruby
data = [{ test_id: 1, test_text: '哈哈哈'}] * 1000
Benchmark.measure { BlankTest.create!(data) }

@cstime=0.0,
@cutime=0.0,
@label="",
@real=27.468047000002116,
@stime=0.2811629999999994,
@total=2.2014759999999924,
@utime=1.920312999999993
```
生成 10w 条 `insert` `sql`

## 2. insert_all (Rails 6 + )
oracle 数据库没有id
```ruby
data = [{ test_id: 1, test_text: '哈哈哈'}] * 100000
Benchmark.measure { BlankTest.insert_all!(data) }
```
生成 1 条 `insert` `sql`

## 3. exec_array(ruby-oci8) 仅针对 oracle 数据库
```ruby
count = 100000
Benchmark.measure {
conn = BlankTest.connection.raw_connection
cursor = conn.parse(
  "insert into blank_tests \
    (id,test_id,test_text) VALUES \
    (survey_operation_histories_seq.nextval,:test_id,:test_text)"
)
cursor.max_array_size = count
cursor.bind_param_array(:test_id, [1]*count)
cursor.bind_param_array(:test_text, ['哈哈哈']*count)
cursor.exec_array
conn.commit
cursor.close
}

@cstime=0.0,
@cutime=0.0,
@label="",
@real=1.8525600000284612,
@stime=0.09075399999999867,
@total=0.3080840000000027,
@utime=0.21733000000000402
```

## 4. 纯sql批量插入

同 2 一样,生成一条 `SQL`
