---
layout: post
title: "JavaScript in Modern Web Apps"
date: 2014-01-03 23:20:08 +0900
comments: true
categories: [What Is, Web Apps]
published: true
keywords: javascript,mvc,angular,ember
description: Creating modern web applications
---

My own prior experience with web development was 14 years ago, and consisted of ColdFusion marked-up HTML and little else. Web pages used frames and tables and a lot of homegrown convention to ensure headers/footers looked right. We were spending most of our efforts on effectively using CSS to make our lives easier - not separating views from data or dynamically updating HTML elements.

This article describes my current understanding of the technologies used in constructing _modern_ web applications, largely based on a few years' lurking on [Hacker News](http://ycombinator.com) and a couple weeks' not-so-intense investigations.

<!-- more -->

### The importance of JavaScript

Javascript is said to be the assembly language of the internet. It was created circa 1995 for Netscape Navigator 2.0 as part of a much grander vision for the Internet. It is supported by all web browsers, and [until recently](https://www.dartlang.org/) was the only language broadly enough available to do so.

Modern web applications are built many layers of abstraction on top of this, library upon library. An extreme and extremely relevant example of this is the [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) (hereafter XHR) function. Prior to HTML5 WebSockets, every [single-page web application](http://en.wikipedia.org/wiki/Single-page_application) used the XHR function to receive dynamic updates from a remote server, though the technique is often known under the more trendy moniker of [AJAX](http://en.wikipedia.org/wiki/Ajax_%28programming%29). Likely few web apps actually use the function directly however - most these days use high-level [MVC frameworks](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (more on these below) to connect the visual elements the user sees in their browser (the view) to entity abstractions updated from a remote server (the model).

It makes sense to me that any understanding of modern web applications would need to be partly underpinned by a solid understanding of JavaScript. It seems like a pretty icky language however, with a lot of stupid idiosyncracies and requiring a lot of idioms to get it to work in a non-crazy fashion. Perhaps because it was [rushed out in 10 days](http://www.computer.org/csdl/mags/co/2012/02/mco2012020007.html).

Here's a few recommendations I would like to read one day:

- [Eloquent JavaScript](http://eloquentjavascript.net/contents.html) - basically an ebook that starts from the basics
- [Learning Advanced JavaScript](http://ejohn.org/apps/learn/) - similar to above only presented as a slide deck with code samples
- [Ask HN - JavaScript Dev Tools](http://news.ycombinator.com/item?id=3550998) - debugging in JavaScript
- [MVC Architecture for JS](http://michaux.ca/articles/mvc-architecture-for-javascript-applications) - building an MVC framework in JS from scratch
- [Large-Scale JS Application Architecture](http://addyosmani.com/largescalejavascript/) - a guy who knows his stuff on various approaches to building 'large' web apps
- [Mozilla Developer Network - Intro to OO JS](https://developer.mozilla.org/en-US/docs/JavaScript/Introduction_to_Object-Oriented_JavaScript) - everything you need to know on how `prototype` and `new` provide OO on top of simple JS function
- [JavaScript Garden](http://bonsaiden.github.com/JavaScript-Garden/#intro) - a kind of FAQ on all the idiosyncracies of JS (how `this` works, for example)
- [JavaScript Patterns](http://shichuan.github.io/javascript-patterns/) - a very nice looking reference on all facets of modern JS (including frameworks)
- [Learning JavaScript Design Patterns](http://addyosmani.com/resources/essentialjsdesignpatterns/book/) - not sure if this is really useful yet, especially compared to the one directly above

### JavaScript in the browser

I tend to avoid spending too long on high level frameworks, as they come and go and are easily replacable. However some toolsets and framework have become totally indispensable, valuable timesavers to anyone making a web application.

- [jQuery](http://jquery.com/) - a low-level toolset that vastly simplifies common JS tasks such as manipulating the DOM and using XHR
- [RequireJS](http://requirejs.org/) - a library that makes including third party modules simple
- [Handlebars](http://handlebarsjs.com/) - a very popular template parser that uses {% raw %}`{{this}}`{% endraw %} syntax
- [Backbone.js](http://backbonejs.org/) - allows user-defined model objects to be dynamically linked up to HTML elements for automatic updates
- [Ember.js](http://emberjs.com/) - an exciting MVC framework that I think is built on top of Handlebars and Backbone, or something like it. More below
- [Angular.js](http://angularjs.org/) - a Google library that promises to deliver similar functionality as Ember.js, but with a syntax that is meant to look more like a natural extension of HTML

### JavaScript on the server

For some reason JavaScript has become a very popular language for performing server-side tasks as well. I think this has something to do with the recent popularity of the [Node.js](http://nodejs.org/) JavaScript web application platform. Node was simplistic enough for people to write small but highly capable tools in a language with which they were already familiar. Regardless of the purpose, it is important to note that the fact that its use on the server side is largely unrelated to its
use in the browser.

I think I'll likely want to look into at least these frameworks:

- [npm](https://npmjs.org/) for javascript package installation
- [Yeoman](http://yeoman.io/) provides a set of tools for creating and manipulating a web app on a workflow level
- [Bower](http://bower.io/) for application dependency management. It automatically downloads and configures dependent frameworks for an app
- [Grunt](http://gruntjs.com/) for running preconfigured tasks from a Gruntfile. For example running, testing and previewing web apps

### Serving and hosting web apps

I've been concentrating mostly on the browser end of the web application architecture equation. So far my thoughts on the matter of hosting haven't really gone too far. Two obvious options come to mind however.

**A Yeoman-generated Application** that I think by default uses a simple web server like [Unicorn](http://unicorn.bogomips.org/), started from a Grunt script. There are plenty of instructions on the web for deploying these applications to Heroku or other hosting services.

**A Rails RESTful Application** hosted on something like <abbr title="Amazon Web Services">AWS</abbr>. Ruby on Rails is a hefty web framework that also follows the MVC framework. I think it's a full-stack framework in its own right and prefers its own HTML templating engine. I intend to use it to expose a REST API instead of HTML however so I can totally separate the server logic from the UI framework, and perhaps write separate front-ends altogether.

