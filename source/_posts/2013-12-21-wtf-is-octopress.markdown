---
layout: post
title: "WTF is Octopress?"
date: 2013-12-21 22:05:43 +0900
comments: true
categories: [WTF Is, Octopress]
published: false
---

[Octopress](http://octopress.org) is a developers blogging engine. It is a single author, statically generated set of web pages that are created anew every time the author modifies or adds a new post. Octopress blogs are hosted on Github Pages, Heroku or any location with an Rsync service running. I chose Github Pages.

TODO: insert image here (include ruby etc)

All of the actual static site generation functionality is actually provided by [Jekyll](http://jekyllrb.com/). Octopress is actually a set of convenience scripts to help make generation of a new blog, post or page, and deployment of the blog as trivial as possible. 

SIDEBAR: created for github? this explains the pages integration

### Quick Start ###

TODO: Create a new blog like...

This is how Octopress is used:

{% highlight bash %}
rake new_post['my new post!']_
vim source/_posts/2013-12-21-my-new-post.markdown_
rake generate
rake deploy
{% endhighlight %}

For markdown syntax, refer to the Liquid [logic tags](http://docs.shopify.com/themes/liquid-basics/logic), [logic filter syntax](http://docs.shopify.com/themes/liquid-basics/output) and 

### So first, WTF is Jekyll? ###

Of course the best documentation is provided on [the Jekyll website](http://jekyllrb.com/docs/home/). All the octo-blogger need understand is the various forms of template mechanisms it provides: Markdown and [Liquid](http://wiki.shopify.com/Liquid).

*Markdown* is usually just a matter of adding intuitive characters to a document indicating things such as emphasised, underlined or strong text, hyperlinks, headings or tables. When Jekyll gets to it however, it turns these into the relevant HTML analogues. 

TODO: examples

*Liquid* is a simple templating language that can be embedded in a markdown file using the {% raw %} {% and %} {% endraw %} tags for logic statements, and {% raw %} {{ and }} {% endraw %} tags for filters. Typically one might include other files, assign variables, affect control flow through if, case, 

TODO: examples

### Installation ###

Hosting
Domain name and DNS

