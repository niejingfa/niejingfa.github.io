---
layout: post
title:  "postgresql 安装及配置"
date:   2019-05-05 16:36:22 +0800
categories:
---

- ### 1.  使用 Homebrew 安装 PostgreSQL
安装
{% highlight ruby %}
  $ brew install postgres
{% endhighlight %}

查看postgresql 版本信息
{% highlight ruby %}
  $ psql --version
  psql (PostgreSQL) 11.1
{% endhighlight %}

也可以安装的时候指定版本， 比如： 
{% highlight ruby %}
  $ brew install postgres@11.1
{% endhighlight %}

如果还没有安装brew services，可以使用以下命令进行安装。
{% highlight ruby %}
  $ brew tap homebrew/services
{% endhighlight %}

然后使用以下命令以后台服务的方式启动Postgres
{% highlight ruby %}
  $ brew services start postgresql
{% endhighlight %}

关闭数据库
{% highlight ruby %}
  $ brew services stop postgresql
{% endhighlight %}

重启数据库
{% highlight ruby %}
  $ brew services restart postgresql
{% endhighlight %}

- ### 2.  配置 PostgreSQL

- 2.1. 默认的安装目录是： /usr/local/var/postgres

- 2.2. PostgreSQL 有两个重要的全局配置文件: postgresql.conf 和 pg_hba.conf, 他们提供了很多课配置的参数， 这些参数从不同层面影响着数据库系统的行为

- 2.3. postgresql.conf 配置文件主要负责配置文件的位置，资源限制，集群复制等， pg_hba.conf 文件则负责客服端的链接和认证

- 2.4. 除身份认真意外的数据库系统行为都由postgresql.conf 文件配置

- 2.5 配置 pg_hba.conf
{% highlight ruby %}
  $ vi /usr/local/var/postgres/pg_hba.conf
{% endhighlight %}

{% highlight ruby %}
# TYPE DATABASE USER ADDRESS METHOD
# local DATABASE USER METHOD [OPTIONS]
# host DATABASE USER ADDRESS METHOD [OPTIONS]
# hostssl DATABASE USER ADDRESS METHOD [OPTIONS]
# hostnossl DATABASE USER ADDRESS METHOD [OPTIONS]
{% endhighlight %}

- 2.6 每一行的作用就是： 允许哪些主机可以通过什么连接方式和认证方式通过哪个数据库用户连接哪个数据。 也就是允许 ADDRESS 列的主机通过 TYPE 方式以 METHOD 认证方式通过 USER 用户连接 DATABASE 数据库

比如： host    replication     all             127.0.0.1/32            trust

- TYPE列 标识允许的连接方式，可用的值有: local, host, hostssl, hostnossl
- local: 匹配使用unix域套接字的链接， 如果没有 type 为 local 的条目则不允许通过 unix 域套接字连接     #  套接字 https://blog.csdn.net/roland_sun/article/details/50266565

- host: 匹配使用TCP/IP建立的链接，同时匹配SSL和非SSL连接。默认安装只监听本地环回地址 localhost 的连接， 不允许使用 TCP/IP 远程连接，启用远程连接需要修改postgresql.conf 中的 listen_address 参数

- hostssl: 匹配必须是使用SSL 的 TCP/IP 连接， 配置 hostssl 有三个前提条件：
  - 1). 客户端和服务端都安装OpenSSL
  - 2). 编译PostgreSQL 的时候指定 configure 参数 --with-openssl 打开 SSL 支持
  - 3). 在 postgresql.conf 中配置 ssl = on

- hostnossl: 和 hostssl 相反, 他只匹配使用非 SSL 的 TCP/IP 连接

- DATABASE列 标识该行设置对哪个数据库生效
- USER列 标识该行设置对哪个数据库用户生效
- ADDRESS列 标识改行设置对哪个 IP 地址或 IP地址 段生效
- METHOD 列 标识客户端的认证方法， 常见的认证方法有 trust，reject, md5 和 password
  - 1). reject 认证方式 主要应用在这样的场景中：允许某一网段的大多数主机访问数据库，拒绝这一网段的少数特定主机
  - 2). md5 和 password 认证方式的区别在于 md5 认证方式为双重 md5 加密， password 指明文密码， 所以不要在非信任网络使用 password 认证方式
  - 3). scram-sha-256 是 PostgreSQL 10 中新增的基于 SASL 的认证方式， 是 PostgreSQL 目前提供的最安全的认证方式。使用 scram-sha-256 认证方式不支持旧版本的客户端库
  - 4). 更多认证方式： https://www.postgresql.org/docs/current/auth-methods.html

- 2.7. postgresql.conf
打开配置文件
{% highlight ruby %}
  vi /usr/local/var/postgres/postgresql.conf
{% endhighlight %}

全局
- 2.7.1. 通过 ALTER SYSTEM 命令修改全局配置，例如：

{% highlight ruby %}
mydb= # ALTER SYSTEM SET listen_address = '*'
{% endhighlight %}

- 2.7.2. 通过 ALTER SYSTEM SQL 命令修改的全局配置参数， 会自动编辑 postgresql.auto.conf 文件， 在数据库启动时会加载 postgresql.auto.conf 文件， 并用它的配置覆盖 postgresql.conf 中已有的配置。这个文件不要手动修改它

- 2.7.3. 启动数据库是进行设置， 例如： 
{% highlight ruby %}
  $ /opt/pgsql/bin/postgres -D /pgdata/10/data -c port=1922
{% endhighlight %}

- 2.7.4. 非全局
设置和重置Database 级别的配置， 例如：
{% highlight ruby %}
ALTER DATABASE name SET configparameter { TO | =  } { value | DEFAULT }
ALTER DATABASE name RESET configuration
{% endhighlight %}

- 2.7.5. 设置和重置 Session 级别的配置
通过 SET 命令设置当前 Session 的配置， 例如：
