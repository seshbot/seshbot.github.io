---
layout: post
title: "The Grand Experiment"
date: 2013-12-20 10:07:06 +0900
comments: true
categories: 
---

A few months ago I decided to hand in my notice and live off my savings for a while. In 13 years of software development this is the first proper hiatus I've taken so I have no idea what to expect.

I intend to spend the next six to twelve months attempting to see what happens when I have time to myself. 

<!-- more -->

### So far.... ###

This is only the first week of my grand experiment. So far I have spent most of it gaming with my other unemployed friends (Pathfinder card game is awesome.) I did set up this blog however, and register seshbot.com, so I suppose it's not a complete loss work-wise.  

### Blogging ###

I'm excited about following an open development process. Source code is only a part of an application however, the analysis and design are integral pieces that I would like to make visible. I am concerned that setting up this blog before I have anything to show is setting the cart before the horse, but it seemed like the smallest most approachable project I could scope out for the first week. 

The Octopress platform seems very developer-friendly. I can trivially embed syntax highlighted source code snippets and extend the framework through a simple plugin mechanism (I think.) There is no fancy web UI for composing posts - its all authoring markup on your local machine then pushing the generated code to github and letting github pages take care of the rest. Writing a new blog post is a matter of:

``` bash
> cd seshbot
> rake new_post['My New Post!']
# Creating new post: source/_posts/2013-12-20-my-new-post.markdown
> vim source/_posts/2013-12-20-my-new-post.markdown
> rake generate
# Successfully generated site: source -> public
> rake deploy
# Generating Site with Jekyll
# Copying public to _deploy
# Pushing generated _deploy website
# Github Pages deploy complete
```

There's of course so much more you can do (preview it locally before uploading for example) but that's the basic workflow.

### Project ###

I have a bunch of stuff I want to mess with, but I intend to start writing a few simple web applications. I have in mind some kind of Ruby-on-Rails stack using [Ember.js](http://emberjs.com/) for the browser's UI modeling. A shared drawing application perhaps? 

Also, I would love to mess around more with C++11/C++14, I have played a little so far and have been very impressed with the productivity and conciseness it affords (it's about time!) A little network game perhaps? I really would love to make a little modular adventure game at some stage. Who knows, perhaps I will be the one to finally make a nice graphical [Dwarf Fortress](http://www.bay12games.com/dwarves/) clone? That seems to be the indy gaming unicorn. 

### Japan Lifestyle ###

So far I have been fortunate but it can be frustrating at times. Living in Japan without a job is a little challenging, though I suspect that would be true in most countries. The immediate challenges are keeping my house (I must renew my lease and they weren't too impressed with the blank 'employment' section of the document) and preparing to pay the various taxes - most notably residential tax and health insurance, both of which are means-based on the previous years income.

I was very happy to discover that just around the corner from my house is a little cafe run by a very friendly independent game-developer - [PicoPico cafe](http://picopicocafe.com). Once a month they hold 'PicoTachi', an event for independent developers (and anyone else really) to show off stuff they've been working on. That seems almost too fortuitous! I am also looking forward to working in the cafe by myself, it has a very nice ambiance. 

