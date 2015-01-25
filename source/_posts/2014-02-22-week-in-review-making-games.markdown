---
layout: post
title: "Week in Review: Making Games"
date: 2014-02-22 10:35:00 +0900
comments: true
published: true
categories: [WeekInReview, C++, Game]
keywords: "C++,C++11,gamedev,game,osx,qtcreator"
description: creating a game in C++ on OSX
---

I have once again bitten off a whole lot - I started making a game based on my fairly limited knowledge of how such things are done, and have found it very difficult to take a moment to distill my thoughts. In fact it has been nearly impossible as I have been constantly unsure of whether the approach I'm taking is actually going to pay off in the long run!

This is just a catch-up on my experiences over the last few weeks, a few discoveries and surprises, and perhaps my plans for the immediate future. I decided at the last moment to include a screenshot here, but I'm sure we've all seen brown circles on green backgrounds before...

{% img /images/upload/2014-02-22-game-screenshot.png "This is a 100m section of a 10km world" %}

I also created a (low framerate) [animated gif](/images/upload/2014-02-22-game-early.gif) of this in action.

<!-- more --> 

## Making a game/engine

The general advice people give new game developers is to never make a game engine - focus on just getting your game concept out. I will largely be ignoring this advice because I don't have a specific idea for a game yet, just a general notion that it will be client/server and a kind of town-builder. Based on this alone I believe that careful work now will be necessary to ensure the scale of the world I have in mind will be possible - the virtual world will almost certainly need
geo-spatial partitioning to ensure location-based entity lookups and collision detections can be performed in decent time, and because only a small portion of the virtual world will likely be viewed, and likely only viewed in a separate client application altogether, there is no reason to have the core game logic mixed in with rendering logic at all. 

### Modularity and the basic framework

I intend to write a separate article on this, but first a quick rundown on my PCX library. I actually spent a lot of time trying to bring some of the nicer IOC container abstractions I've grown used to in .Net and Java to my C++ environment. Breaking an application up into abstract services is a great way to ensure minimal coupling and well designed boundaries around modules of code. This usually involves a lot of reflection in newer languages. My solution in C++ involves run-time type identification (RTTI) which is generally considered anathema in C++, but it can facilitate the creation of libraries that deal in terms of interdependent types, and have nothing to do with the functionality of those types per se.

I decided on these core high-level abstractions:

 - _services_ are the core contracts that different sections of code use to communicate with each other. If you want to work with the weather, get yourself a hold of the weather service
 - _commands_ are messages sent into the application as a whole from outside - services can advertise which commands they can respond to, and the client application can bind keys or whatever to these commands. This abstraction is probably more focused on games
 - _modules_ provide concrete implementations of a bunch of specifically configured services and expose commands. The application mainline only interacts with modules - it starts them up and shuts them down, and the modules provide all the functionality of the application
 - _message bus_ provides singleton channels for application-wide cross-cutting concerns. I have not yet found a particular use for this, but intend to use it for sending 'hints' out that have no true affect on the state of the application, such as _dump debug information now_.

The central idea is that different abstract concepts such as geography, creature behaviour, economy, weather, client UI etc are all provided by separate modules. When started up, a module can publish services they provide and consume services provided by other modules via a 'service locator'. It is very important that the 'service locator' is only used by the high-level module code directly to ensure they're not used to hide globals and introduce crazy interdependencies. The module creation
mechanism provides a fluid dependency syntax that ensure each module is initialised after the modules on which it depends (i.e., publishes services which this module consumes.)

I created a core library (I named `pcx` after my own initials and the letter 'x' which is super cool) that I intend to be useful as a general-purpose C++ library for anyone wanting to add these concepts to their own application. 

### Deciding on core abstractions

I've been thinking about making a game for a long long time now, and have had a myriad of thoughts on how I would create all the major abstractions, modularise the code, and manage multiple clients, network latency, sharding, etc. But when I actually sat down and put hands to keyboard, the first problems I ran into were hugely and unexpectedly daunting - how should position and rotation be stored? And time? Should position be a vector of floating point numbers or integers? And
should velocity be another vector, or polar coordinates (rotation and magnitude). Should rotation be implicit from velocity, or should entities be able to face one direction but move in another? 

These are all decisions that will affect the application in almost every way, and doubtless create deep-seeded performance and functionality trade-offs, and as this is my first game I wasn't really sure what those might be. For example, if I choose to represent velocity as a vector (x, y components), then I lose the ability to determine the direction a stationary unit is facing ([0,0] gives no information in that aspect). Polar coordinates do not suffer this problem however. But the
calculation for moving an entity with cartesian vector velocities is so trivial! Just `newPos = pos + velocity * time`... It's very tempting to go with that!

And if I store latitude/longitude of an entity as floating point numbers, I expect I might run into rounding problems with entities far from the origin point. Or when comparing entities close to the origin with those far from the origin. But floating point numbers allow me to say 'all distances are in meters' which makes thinking about and configuring the application that much easier for me. 

In the end I kind of arbitrarily chose to store locations and velocities as vectors of doubles, and will probably store a 'facing direction' as a float in radians. Real-time time is likewise a double, indicating fractions of a second. I have not yet implemented any concept of in-game time however. 

### Discovering engine capabilities

I quickly found it very important to keep a close eye on the performance impact of all my decisions as well. It was quite exciting to get my original simple framework up (a 'world' module that holds all the entities and their locations/momentums in the game) and determine the maximum number of visible entities it could support. I found it started dropping frames at around 40,000 moving entities in the world, but I quickly realised however that I have no idea what a good number is - how many entities _should_ it be able to support?

Most engines I've looked at (e.g., Quake and Source engines) suport the low 1000's of entities, but most of those are client-only frameworks. I couldn't find a lot of info on MMOs (not that I'm making an MMO but I would like to get a feel for scale), and could only find indirect references to EVE online supporting [up to 30K entities in some of their major battles](http://www.gamasutra.com/view/feature/132563/infinite_space_an_argument_for_.php?page=2), but they apparently do all sorts of crazy stuff to support that such as slowing down time and moving entities not directly involved out onto other shards. 

In the end it's all moot however, as my game is still very trivially implemented and is not a real-world example of how it will eventually work. For one, all moving entities in the world just walk in an anti-clockwise circle and don't look at the world around them (this will add a lot of complexity to say the least!). Secondly, the game currently updates every entity in the game 60 times per second. I should definitely make entities further from the player 'stupider' and less
frequently updated, and there is actually no good reason to update all entities 60 times per second anyway - that number was chosen because that is the framerate of the GUI and I have currently tightly bound the world update logic to the core game loop. I will be decoupling these soon.

I have found it's very interesting to keep a good feel for the performance of the application as I work on its foundation - every time I make a significant modification I run it with varying conditions and check how it performs relative to previous iterations. This has led to some interesting discoveries regarding performance of iterators and iterator adapters, and some very puzzling edge-cases where the Clang optimiser seems to suddenly start borking. But more on that some other time. 

The 'modules' abstraction is really helpful in monitoring performance - the core game loop just iterates over each module, effectively saying `for each module m, m.update(timeSinceLastUpdate)`. I put a basic metrics counter around this tight loop and get some pretty useful output that shows how many milliseconds each module consumes per tick:

``` bash Stats are dumped to standard output ever second
Job time accumulations in 1000ms:
 -               client - 60 ticks, avg: 0ms max: 0 total: 0ms (0%)
 -                 mobs - 60 ticks, avg: 0ms max: 3 total: 9ms (27%)
 -                props - 60 ticks, avg: 0ms max: 0 total: 0ms (0%)
 -                world - 60 ticks, avg: 0ms max: 0 total: 23ms (72%)
 -      render entities - 58 ticks, avg: 5ms max: 8 total: 339ms
 -   update all modules - 58 ticks, avg: 0ms max: 3 total: 33ms
```

From this output it is obvious that the 'render entities' step is taking a long time - I should really investigate this!

### C++ development experiences

Regarding the choice of C++ as a language, it is sometimes a boon and often times a bane. The absolute major pain I'm trying to avoid is massive compile and link times. These can only be mitigated through careful control of modularity and inter-dependencies. This is something one should struggle to achieve in any case, but it is constantly undermined by the use of templates and libraries that use templates. 

And the Eigen C++ matrix library seemed like a good choice, but it comes with a harrying legacy - it prefers to use special high-performance instruction sets available on some machines that require your objects to be defined in a certain way (with special alignment specifications when memory is allocated.) These are known as [fixed-sized vectorisable](http://eigen.tuxfamily.org/dox-devel/group__TopicFixedSizeVectorizable.html) types and can cause segmentation faults if used incorrectly. Fixed-size vectorisable types cannot be passed by-value to functions or methods, and all classes that contain
such types must themselves specially override the _new_ operator to ensure these alignment requirements are maintained. And STL classes that contain these types must take this into account, so Eigen provides its own implementation of the STL vector that you must use. PLUS all of these restrictions apply to types that you create that have eigen members, and I think also to classes that aggregate THOSE types! It is a huge pain in the ass if you like creating abstract interfaces, to say the least. 

I suspect that Eigen will cause all sorts of problems when I move to Windows, so I want to try that out sooner rather than later. The special vectorisation can be disable at compile time but I'd rather see if it causes problems first. 

## Qt Creator and CMake

I was originally going to go with XCode for development on OSX - I'd really love to learn how to use that well as it seems quite different to most other editors and not intuitive for me. Ultimately however I decided against it because it doesn't work well with CMake (I think I would have to constantly be re-loading the project) and, at the time anyway, I was thinking that I really wanted to work with QT Quick and other Qt technologies.

So I decided to go with Qt Creator as a development IDE. It is certainly a huge pleasure to use, and has more than the usual amount of high-level functionality one would expect in a C++ development environment. As a bonus it has fairly decent integration with CMake - the only missing aspect here is that it doesn't allow you to easily add files to your CMake project, but I have made a few tools that allow me to do this easly from the command prompt (more below.)

The main problem I've had so far is that in order to use the latest C++11 functionality I went with Clang over GCC as a compiler. While Qt Creator supports this, it still seems to try to use the GDB and GProf etc for debugging and profiling, which don't work with Clang. I am going to spend some time soon figuring out how to fix this, but it seems to involve creating a new 'kit' that defines which dev tools the IDE should invoke. It seems complicated however...

## OSX Development

I really enjoy working on OSX - it has all the goodness of a good linux development environment along with some really smooth apps. 

One of the worst aspects of Windows development is the extremely weak command line environment. The history of the command line shell (MS-DOS prompt) still seems mired in its QDOS (Quick and Dirty Operating System) origins from the very early '80s. While it supports basic pipes and has a few commands like `find` and... erm... anyway, while it has some limited functionality available, it is not a scratch on the highly evolved GNU/Linux environment that has been continually improved over
the last 30 years or so. If you want a tool that does anything moderately complex in Windows you need to find one on the internet generally, whereas in Linux there is no limit to what can be accomplished with `sed`, `grep`, `find`, `cut`, `awk`, `tr` and the like.

For instance, one real annoying aspect of C++ development for me has always been the relative difficulty of creating new projects. Java IDEs can easily provide the ability to create new projects and packages through a simple right-click in your project tree, because Java is very opinionated about where such files go. C++ just requires the symbols to _exist_ at link time, so they could come from anywhere, and there are limitless conventions about how to manage header files in your filesystem. 

I have my own conventions for managing my hierarchy of source and header files, and decided to create template projects and modules (my own abstraction for this project) and create shell scripts that allow me to set up entirely new projects with a simple `x.new-module thing Thing`, which will create all the necessary headers, source files and CMake files, with default sensible names and namespaces, and include them into my current project. This would have been a nightmare to put together
in Windows but has been trivial in OSX.

## Next steps

I recently added the all-important geo-spatial partitioning in a very simple way, but this seemed to cause some significant performance penalties. I have decided to take the plunge and figure out how to get the profiler working properly with Qt Creator to help me investigate this, because working on a large project without a profiler is like driving a car with a map but no windows - it's hard to tell if you're still on the road.

I really want to get some graphics in there but I have no experience with that, so am considering messing around with shaders to see if I can get a good lighting model in there first. This should really help me figure out the environmental aesthetic I'm going for. 

At some stage I'll need to figure out how I'm going to make the game overlays such as menus, dialogs, text boxes etc. Previously I've used SFGUI (works well with SFML which is the C++ GUI library I'm using) but I would like to see if I can get QT Quick and QML working with SFML. I don't want to spend too long on this however because I intend to move the GUI code to perhaps another language (C# and Unity) so effort spent on the GUI might be ultimately wasted.

