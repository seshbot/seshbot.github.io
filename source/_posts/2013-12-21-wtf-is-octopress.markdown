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

### Quick Start

TODO: Create a new blog like...

This is how Octopress is used:

``` bash The simplest Octopress workflow linenos:false
rake new_post['my new post!']
vim source/_posts/2013-12-21-my-new-post.markdown
rake generate
rake deploy
```

Typically, you will want to preview your changes before deploying them however. Octopress makes this simple - running <code>rake preview</code> will set up a simple web server hosting your blog on <code>localhost:4000</code>. As a bonus, you can skip the generation step by running <code>rake watch</code> in the background - this will automatically run <code>rake generate</code> every time you change a file. (See the section on POW! for an /even simpler/ way of doing this on OSX.)

For markdown syntax, refer to the Liquid [logic tags](http://docs.shopify.com/themes/liquid-basics/logic), [logic filter syntax](http://docs.shopify.com/themes/liquid-basics/output) and 

### So first, WTF is Jekyll?

Jekyll is a ruby application that generates a complete static HTML website based on a directory full text files that have been marked up with simple formatting hints. If you want to make a simple site, or add a content generation component to an existing web application, Jekyll looks like it might be feasible (also perhaps have a look at [Prose](http://prose.io), which purports to be an attractive content editor for GitHub.)

SIDEBAR: created for github? this explains the pages integration

Of course the best documentation on the functionality Jekyll provides is provided on [the Jekyll website](http://jekyllrb.com/docs/home/). All the octo-blogger need understand is the various forms of template mechanisms it provides: Markdown and [Liquid](http://wiki.shopify.com/Liquid).

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
 - asides (adding a sidebar, shown on all pages) using featured: true
 - incorporating themes, modifying templates and styles

Syntax highlighting: http://octopress.org/docs/blogging/code/

Notes on styling: the scss directory is probably where you want to be - for example the sass/base/_font.scss_ file contains several variables that are used throughout all the other styles. The defaul theme doesn't use a fixed-width font for its <code>pre</code> and <code>code</code> selectors - I discovered that this can be amended by simply changing the <code>@fixed-width</code> variable in that file. 
http://minizatic.github.io/blog/2013/08/06/customizing-an-octopress-theme-and-installing-plugins/

http://blog.bigdinosaur.org/changing-octopresss-header/

### Installation

Hosting

Domain name and DNS

themes

install, generate and deploy

### Usage Scenarios

new_post, new_page, generate, preview, deploy

custom HTML elements

### How Octopress generates a site

front matter: tags - available as page.mytag

All files in the <code>source</code> directory are rendered with Jekyll. The convention is:

<code>source/*.html</code> describes how to render each requested page

<code>source/_posts/*.markdown</code> describe how to render each post page

Each template contains /front matter/ describing, among other things, which layout renderer to use. The layout renderers are in the <code>source/_layouts/</code> directory. These include the <code>default</code>, <code>page</code> and <code>post</code> layouts. The <code>default</code> layout sets the root_url variable, includes the head, header and footer templates and appropriate content.

### Bonus for OSX users - POW!

http://pow.cx 

```bash
curl get.pow.cx | sh
```

http://jerryclinesmith.me/blog/2012/08/07/installing-pow-via-homebrew

