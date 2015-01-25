---
layout: post
title: "This week in review: my game table web app"
date: 2014-01-11 11:19:08 +0900
comments: true
categories: WeekInReview Ember
published: true
keywords: ember,deployd,javascript,development
description: reviewing my progress, starting a new ember.js application
---

First here's a quick summary of what I got up to:

1. trying to build a simple 'gaming table' application in Ember.js,
2. styling with Twitter bootstrap,
3. messing with plugins in my blog (trying unsuccessfully to fix code highlighting, and adding a UML tool - see below)

{%uml%}
title The Awesome

package "Look!" {
  object "Paul" as 2
  object "Can" as 3
}
object "Do" as 4
object "UML!" as 5

2 .right.> 3
3 o-down-> 4
4 - 5
{%enduml%}

I spent most of my time learning about Ember. [Ember.js](http://emberjs.com) is a very nice looking front-end MVC framework that has a very appealing [getting started guide](http://emberjs.com/guides/) that make it look _super simple_ to create a reactive application. Three things that people will not tell you however: 

- demo videos only ever show the main usage scenario of that framework
- most new frameworks change so often that they're either unstable or very little up-to-date documentation exists, and
- many of the benefits they offer you probably won't end up using anyway, for various reasons

For now though I'll go ahead with it because I feel that I'm just about to start doing cool stuff in it (it kinda always feels like this though.)

**Next week** I'm thinking of switching back to some C++ stuff so I can dabble in a realm I'm more comfortable with for a while... Monday is a public holiday in Japan though so I'll probably be wandering around and not programming much.

<!-- more -->

### Problem 1: binding non-nested components was difficult

I figured I would devote my first day last week to creating the framework for a small Gaming Table application. Perhaps just start off with a quick chat client or sketching app. I was not accounting however for the vagaries of modern web application development, and I ended up messing around with stupid little problems for most of the week. Looking back I feel it was quite frustrating overall - it seems that many of these new techs do not quite work as advertised, if at all.

Most tutorials and documentation will usually only tell you about one way to make an ember app - showing the details of a single entity or collection of entities of the same type at a time. Perhaps it might be some blogging application that lets you dig down into various blog entries, or perhaps it will involve showing all the tweets from a particular tweeter. Whatever the demo, I'm sure it will show you how to explore _a single concept_. 

The first thing I wanted to do was to show your online friends on the left side and allow you to create or enter an existing chat room. I immediately got stuck on a stupid little problem however that I stubbornly refused to get past, leading to several wasted days.

My specific problem was _how can I make the nav bar show the name of the current gaming table (kind of like a chat room), but show some placeholder message if I'm not in a room_. The problem being that the region dedicated to showing information about the current table (players, cards etc) is not a descendent hierarchically of the nav bar.

{% uml %}
title Game Table Basic Layout

package "Nav Bar" {
   [Game Selector Widget]
   [Current Game Name]
}

Package "Play Area" {
   [Game Table]
   [Friends Widget]
}

[Game Table] .up.> [Current Game Name] : update on change

{% enduml%}

Long story short, the correct way seems to involve: 1) modifying the 'Nav Bar' controller to add a dependency to the 'Game Table' controller; 2) add to the Nav Bar controller an alias or dynamic property pointing to the Game Table controller (this is conceptually the last table loaded); and 3) creating another dynamic property in the Nav Bar controller that is updated whenever `currentPath` is updated, and returns `null` if the route (`currentRouteName`) is no longer a table.

This might make sense, but it was a pain in the ass to discover. (Side note: I'm working on a general 'getting to know Ember.js' post that goes into a lot more detail on this so others tackling the same problem might not have to spend as long as I spent on it.)

{%pullquote%}
I'm not saying the framework is terrible, but {" all of the Ember help I found is out of date, and none of the code samples I found worked. "} Ember only reached v1.0 4 months ago (Sept 2013) so any advice from before that period is probably out of date. Code samples will not work, and jsfiddle/jsbin apps will probably not run, which is a huge problem because that is how people communicate working code samples with each other in this community.
{%endpullquote%}

I'm concerned that the Ember docs might not cover enough real world scenarios that 'proper' applications might encounter (e.g., several regions dedicated to different information.) 

### Live Help in IRC! 1980's tech to the rescue

The IRC channel is pretty awesome - the #emberjs channel of freenode.org is one of the most populated channels on the server, and I've saved a lot of time by asking for help there. 

I spent a long time digging through documentation on how to solve this problem before I turned to IRC. Then within 10 minutes I had someone giving me meaningful advice that I ended up using. The secret was that I went in there with a minimalistic example of my problem that they could mark up and fix for me. [Here's](http://jsbin.com/UzaFUZE/1/edit?html,js,output) the code I gave them and [here's](http://jsbin.com/UzaFUZE/4/edit?html,js,output) what they gave me.

### Hosting a backend

I have been mainly concentrating on the front end functionality so far, so didn't want to spend too long messing around with the server side. I had originally decided that I'd learn some rails, but decided to try out a 'no backend' solution - in this case [deployd](http://deployd.com). The two criteria I was after were a simple REST API and some kind of authentication, both of which deployd ostensibly offers. There were a few hiccups though. 

The first was that deployd is still actively being developed, so the web UI isn't totally intuative. I won't go too far into it but it has been a hassle. 

The next problem is that although both Ember and Deployd declare that they speak standard REST JSON language, it turns out they don't agree on how that language should look. I had to mess around a fair amount and ask around on IRC before discovering that you need to apply your own serializer, that intercepts all remote data transfers and allows you to 'munge' it a little into a format that Ember is happy with. 

Again, I'll include the details of all this in a post dedicated to Ember later.

