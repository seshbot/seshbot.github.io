---
layout: post
title: "Week in Review: back from my hiatus (from my hiatus)"
date: 2015-01-24 04:49:15 +0000
comments: true
published: true
categories: [WeekInReview, C++, Game]
keywords: "C++,Qt,QtQuick,QML,OpenGL"
description: learning OpenGL by creating docs
---

In September I went to Spain for 6 weeks to chill out with my family and check out what the countryside had to offer. Then I moved from Japan to Australia and got caught up in the Christams spirit. So although I have done some stuff (below) I have not made much progress on any big projects in the last few months...

BUT I have done a lot. Below the fold I talk about starting a C++ OpenGL library, creating some nicer OpenGL documentation, learning Blender 3D, setting up a new computer and moving country. 

On the side I've been helping a mate out set up an e-commerce site for his new Japanese brewery - more information to come when it is released in a few months!

<!-- more -->

## Australian lifestyle

Things are __really__ breezy here - it is a great relief to be in a country where I can just pick up a medicare card, or drivers licence, or bank card, or ANYTHING that involves beurocracy and signing documents without worrying about not understanding or sitting through hours of pawing through contracts and legalese, or running up against brick walls because I'm a foreigner. Although the service is generally not as nice as that in Japan, people are more willing to take the initiative when helping you out.

Everything is a long drive away. The computer store [PLE](https://www.ple.com.au/) is easily a 30 minute drive away, out in one of Perth's industrial areas. Oh and speaking of that, there are very very few good computer stores around here. PLE is fantastic however, all staff members I've spoken with are really knowledgable about hardware and have been super helpful.

Pretty soon I'll set up an ABN (business entity) because its easy to do and I would like to make some business cards... 

## My new office

I'm currently living in Kalamunda - a beautiful area in the hills east of Perth, although it's a bit far from anywhere (as is everything else in WA!) As predicted the internet in Australia has been nothing but trouble, but we are close to the exchange so once I get some technical stuff sorted out we should have OK speeds (although with a download cap which feels very 90s).

The big lesson I've learned is that no company that provides a utility (e.g., telephony) should ever be privatised. They live in a privileged state of natural monopoly and will always screw their customers by providing the cheapest possible service, if any service at all.

## My new computer

To celebrate moving to Australia, and because my old office computer is in a box on the ocean somewhere, I decided to get a new well-spec'd machine. Having last built a machine about 15 years ago I decided to trust in the most recent [ArsTechnica system guide](http://arstechnica.com/gadgets/2014/08/ars-technica-system-guide-august-2014/) by largely basing my decisions on the [Hot-Rod specifications](http://arstechnica.com/gadgets/2014/08/ars-technica-system-guide-august-2014/4/) contained therein.

It features:

 - CPU: [Intel Core i5-4590](http://ark.intel.com/products/80815/Intel-Core-i5-4590-Processor-6M-Cache-up-to-3_70-GHz)
 - Motherboard: [Asus H97M-E](http://www.asus.com/au/Motherboards/H97ME/)
 - RAM: 16GB (2x 8GB) DDR3-1600 (can't recall brand)
 - SSD: [Samsung 840 EVO 250GB](http://www.samsung.com/au/consumer/pc-peripherals/solid-state-drive/ssd-840-evo/MZ-7TE250BW)
 - Case: [Corsair Obsidian 350D](http://www.corsair.com/de-de/obsidian-series-350d-micro-atx-pc-case)
 - GPU: I reused my NVidia 550 GTX from my previous machine
 - PSU: I also brought my old 750W power unit from Japan

Windows 8 boots up _really_ quickly and the machine in general is just super speedy and a pleasure to use. I am especially happy with the case, it pops open and closed easily without tools and has fantastic airflow and filtering.

## New OpenGL work

I have put aside the game stuff I was doing to focus on my core OpenGL knowledge a bit. OpenGL is crufty and problematic to use, and often if you make a mistake it can take hours or days to figure out what the problem is. 

As such I begun work on [glpp](https://github.com/seshbot/glpp) - a C++ library that provides a strongly-typed interface to OpenGL that also features utilities to easly create rendering pipelines, typed buffers, and under the covers utilises third-party libraries to provide context creation, image loading and 3d model loading. It also builds on OSX and Windows (using ANGLE so you dont have to install your own OpenGL drivers!) and targets OpenGL ES 2.0 to ensure maximum support across platforms. 

I want to try automatically generating my type-safe versions of the OpenGL API (enums, bit fields and functions), and would like to somehow transform the [Khronos OpenGL API Registry](https://cvs.khronos.org/svn/repos/ogl/trunk/doc/registry/public/api/gl.xml) to reduce the amount of manual work required. In considering this I came up with another idea - how about making some nice interactive documentation that doesn't suck as much as all the other docs!?

So with this in mind I have started experimenting with creating a static single-page-app with Ember.js that will source a set of auto-generated JSON docs of my own fashioning, using the 'fixture adapter' instead of loading data from some REST-ful service. I created a github repo called [gldoc](https://github.com/seshbot/gldoc) which I'll be pushing my efforts into. For now it's just a small skeleton Ember app though, as I struggle to recall how Ember works. 

Of course instead of writing an ember app and generating the JSON data I could just generate a bunch of static pages (or maybe make it single page with creative uses of divs, jQuery and handlebars), but I would like to mess with ember a bit more so I'll go down that route. 

In other news however, Microsoft has release Visual Studio 13 'community edition' which is totally free to use! This is fantastic news as the 'express edition' was missing a bunch of features I really like using such as performance profiling and the interactive command window, among other things.

## 3D modelling with Blender

To cut a long story short, Blender is a very nice 3D modelling application. If you want to learn it I would highly recommend starting with the [Blender Cookie introduction for beginners](http://cgcookie.com/blender/cgc-courses/blender-basics-introduction-for-beginners/) series of videos. Also, install the 'pie menus' (look it up) - they make switching between states super simple.

{% img /images/upload/2015-01-25-dude.png "I made a dude" %}

## Games

I went a bit crazy and decided to start playing Dark Souls and the new Elite: Dangerous. 

Dark Souls is so awesome I am considering making a lets play video as I've seen others do. I downloaded [OBS](https://obsproject.com/) and am excited to give it a try. 

Elite: Dangerous is a fantastic successor to the Elite games of the 80s, made by the same guy via KickStarter. The feel of the game is fantastic, but the multiplayer aspect is quite lackluster at the moment - it is very difficult to locate your friends or help them out in battles etc. But at least it HAS a multiplayer aspect! 

In fact I enjoy the game so much I purchased a [ThrustMaster T-Flight HOTAS X](http://www.thrustmaster.com/products/tflight-hotas-x) which makes the experience much better. I am seriously considering an Oculus Rift as well, as in addition to the natural synergies with this game, I'd love to try making some software for it. 

Finally, I headed into Tactics in Perth and purchased Ticket to Ride, Munchkin and an Adventure Time card game as well.

## Blogging

I have learned so much about OpenGL over the last few months that I can envisage a 4 or 5 part series of articles on the subject. Specifically exploring what OpenGL is and how to get started, how to set up a simple 2D scene, how to set up a typical 3D scene (including shading), shadows and stencils, frame buffers and render pipelines, and texturing.
