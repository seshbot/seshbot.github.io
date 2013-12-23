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

### Quick Start

TODO: Create a new blog like...

This is how Octopress is used:

{% highlight bash %}
rake new_post['my new post!']_
vim source/_posts/2013-12-21-my-new-post.markdown_
rake generate
rake deploy
{% endhighlight %}

For markdown syntax, refer to the Liquid [logic tags](http://docs.shopify.com/themes/liquid-basics/logic), [logic filter syntax](http://docs.shopify.com/themes/liquid-basics/output) and 

### So first, WTF is Jekyll?

Jekyll is a simple ruby application that generates a static HTML blog based on a directory full text files that have been marked up with simple formatting hints.

Of course the best documentation on the functionality it provides is provided on [the Jekyll website](http://jekyllrb.com/docs/home/). All the octo-blogger need understand is the various forms of template mechanisms it provides: Markdown and [Liquid](http://wiki.shopify.com/Liquid).

*Markdown* is usually just a matter of adding intuitive characters to a document indicating things such as emphasised, underlined or strong text, hyperlinks, headings or tables. When Jekyll gets to it however, it turns these into the relevant HTML analogues. 

TODO: examples

*Liquid* is a simple templating language that can be embedded in a markdown file using the {% raw %} {% and %} {% endraw %} tags for logic statements, and {% raw %} {{ and }} {% endraw %} tags for filters. Typically one might include other files, assign variables, affect control flow through if, case, 

TODO: examples

### What is Octopress then?

Octopress is a ruby application that adds to Jekyll the ability to deploy to remote blog hosting services, a set of HTML templates that render nicely on mobile devices and PCs alike (incorporating, for example the Twitter bootstrap framework), and a plugin framework with lots of plugins generally useful in blogs (commenting, twitter, facebook etc integration).

The core concepts you'll need to get a grip on are:
 - generation of the blog, and using git to track your changes (and publish the blog!)
 - posts and pages, and how to create and edit them
 - configuring posts and pages by modifying the ['front matter'](http://jekyllrb.com/docs/frontmatter/) that allows post categorisation, tags, and the published/unpublished marker, among many others. 
 - formatting posts following the markup rules (markdown and liquid)
 - incorporating themes, modifying templates and styles

### Installation

Hosting

Domain name and DNS

themes

install, generate and deploy

### Usage Scenarios

new_post, new_page, generate, preview, deploy

custom HTML elements
