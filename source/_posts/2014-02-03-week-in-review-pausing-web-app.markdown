---
layout: post
title: "Week in Review: Pausing Web App, Starting C++ App"
date: 2014-02-03 07:52:52 +0900
comments: true
categories: WeekInReview Ember C++
keywords: "Ember,Rails,C++,Web"
---

Just over a week ago I decided to put down my web tools for a while and move to working in an environment in which I'm much more comfortable - C++. I will definitely pick up the 'Table Top' app (or whatever it turns into) again soon but I felt the need to do work that resulted in a more _tangible_ product.

Over the last few weeks I've had a growing realisation that the foundation of web programming is still immature, and I am doubting the value in investing too much time learning the high-level technologies. I am not really one for learning frameworks in general actually - I much prefer learning languages and idioms - and modern web programming is all about rapidly changing high-level frameworks. 

That said however, I feel that I'm finally at a point where I can start making useful stuff in Ember and Rails without feeling like I'm misusing the tools or spending most of my time in Google. So last week I knocked off a few high-level features in my app to show the basic scaffolding I was considering (it only took a few hours in the end!), and then set it aside. 

{% img center /images/upload/2014-02-03-seshbot-framework.png "Game Table App as of Feb 2014 - still doesn't do much" %}

There is a very duct-tape and chicken-wire feel to web technologies, but once you're familiar with the tech you can pump stuff out pretty quickly. Because of the immediate and ethereal nature of the web it can be a fantastic way of creating a product that is immediately globally available. All of the magic we see however is still largely magic however, and magic doesn't bode well in any application. The web as a platform for applications is still unbaked and young, and I feel that unless you're forging new territory on the frontier you're probably working with technologies that won't be interesting in a few years time.

<!-- more -->

## The Web as a Software Platform

HTTP, HTML, JavaScript and CSS have been around for a while now, so why have all the useful standards for building proper web applications (like WebGL, WebSockets, local storage, drag-and-drop and all those other HTML5 goodies) only started coming along recently?

It turns out that for a long time web standards were committee-driven by a group of beard-stroking high-falutin non-visionaries called W3C. I still recall fairly recent times when the latest advances in the web were all about creating HTML that was also standards-conforming XML for some reason (so that perhaps machines could deal with it more easily or something?) and very little practical advancement was being made. (Side note: the same thing seems to be happening with OAuth, which is a morass of unproven ideas and conflicting ideals.)

At some stage however another working group arose called [WHATWG](http://en.wikipedia.org/wiki/WHATWG), formed of people that were actually interested in pushing practical new technologies onto the web, and they pretty much ignored the W3C's direction. 

The WHATWG formed in 2004 in response to the stagnating web standards, and in 2007 the W3C finally got on board and standardised HTML5 based on a whole bunch of the WHATWG's tools. They pretty much totally abandoned their whole XHTML thing, which I don't think anyone really regrets.

All of a sudden there have been bursts of innovation on the web, but without a fully baked platform on which to create them. So all these high-level frameworks have temporarily filled the gaps while the HTML spec catches up. In fact, Google's Angular framework (an alternative to Ember.js) has the explicit goal of becoming obsolete when Google manages to get their tools into the standard - it's a kind of proof-of-concept of Google's vision for client-side application development. 

I chose Ember because if you're going with a framework, you might as well go with one that provides abstractions that make sense to you. But I don't have high hopes for it's long-term availability as the web matures, and so feel that there is limited long-term value in becoming some kind of Ember guru.

## My Web App

The current proof of concept is at http://seshbot.herokuapp.com. It still doesn't have the meat in it but it has the authentication, some mobile-friendliness, and sorta models the notions of 'games' and 'players' in games. 

I was much surprised to find out that there is not much of a story yet for how to provide a real-time connection between the backend and the Ember application, where updates on the server are actively pushed out to the client. This is probably the next big thing I'll have to do - create an adapter that connects to the server (probably using server-side events and one of the [Rails4 streaming APIs](http://www.sitepoint.com/streaming-with-rails-4/)) and injects incoming updates into the model using the Ember Data API, similar to the [EmberFire Firebase library](https://github.com/thomasboyt/ember-firebase-adapter).

Other than that, the two remaining things I can think of are: making it look like a gaming application (nice rose-wood tabletop look or something?) and adding a few components that I want to have in there like a chat client, a dice area and some kind of card game. This is the nice bit where I get to play around with things, I'm looking forward to experimenting with the interactivity side of things, perhaps dragging cards around or having some sound built into it. 

I have put this aside however because I don't want to burn out on it. I think it's time to take a break so that I can come back with a fresh set of eyes - perhaps I'll decide it's not worth continuing at all in lieu of some other app.

## New C++ App

I've been wanting to mess around with C++11 for a long time now, and have made a lot of little sample applications that allow me to get a feel for it. I really want to try creating a real application that is:

- cross platform
- uses built-in C++11 stuff like chrono, threads, lambdas, auto etc
- provides a few services I've come to enjoy in newer languages such as dependency containers (if feasible!)
- allows me to experiment with GL shaders, which I've wanted to play with for _years_.

So I spent a few days writing a basic app in [QT Creator](https://qt-project.org/wiki/Category:Tools::QtCreator) using [CMake](http://www.cmake.org/) as the build system. There were a few hurdles but it didn't take long to get up and running. Because I'm limiting myself to core C++, boost and a couple of cross-platform libraries ([SFML](http://www.sfml-dev.org/) for graphics and [Eigen](http://eigen.tuxfamily.org/index.php?title=Main_Page) for linear algebra stuff) it's still pretty versatile. And because I'm using CMake I'll be able to use Visual Studio to develop in Windows and QT Creator or XCode or whatever I want in OSX. I'll try to stick with QT Creator where possible though for consistency.

{% img center /images/upload/2014-02-03-qtcreator.png "QT Creator actually looks pretty nice" %}

I am a bit worried about Windows compatability - Visual C++ has always lagged behind in standards conformance, but they have picked up their pace somewhat in the recent future. I am avoiding some of the more esoteric stuff however, such as variadic templates, because of VC++.

I would also really like to try messing around with QML - Qt's DSL for writing GUI applications. It reminds me of WPF only in a much cleaner, less hacky way, with JavaScript capabilities built straight into it. Ideally I will figure out a way to use Qt Quick/QML seamlessly with the OpenGL stuff provided by SFML, though I am less optimistic about that. Previous experience tells me that you don't want to be re-creating GUI widget libraries because layout management is a complete bitch, but I think QML is still a bit young to work in arbitrary circumstances.

## Blogging

I found it very difficult to blog about my experiences with Ember and Rails. There is a lot of stuff out there covering the same stuff I would cover, only terribly out of date. This made me feel that my posts too would just become so much flotsam on a sea of irrelevant minutiae. 

The main value I was really getting though was as a reference for myself so I could close some of my browser tabs without worrying that I wouldn't be able to find that one piece of information again, and also so that I could distill my thoughts on something before putting it aside. 

I have about 3 unpublished posts on my experience over the last few weeks - I'll probably put them together under one post about Ember development, but not for a little while now I'm guessing.

I am much more certain of my opinion on C++ related matters, so I imagine that there will be a few long rants in that general direction coming up.

