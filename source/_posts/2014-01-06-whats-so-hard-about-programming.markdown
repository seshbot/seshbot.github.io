---
layout: post
title: "What's so hard about programming?"
date: 2014-01-06 20:19:49 +0900
comments: true
categories: programming
description: a discussion on the different aspects of programming, and why it can be so difficult
keywords: programming, C++, analysis, design, UML
---

It is a fact that every programmer is the star of their peer group, and would spin out the most awesome cleanly-built apps if only he or she didn't have to work under these circumstances. It is also a fact that every programmer understands that they were terribly misguided just a few years prior. 

Given these two facts, I would have to think a whole lot of myself to give advice on programming to other programmers. I happen to know however that I am in fact a better programmer than most, and am therefore uniquely qualified to offer such advice.

So here's some of the things I feel I've learned the hard way - at least enough that every time I work on a project they jump to mind and guide my actions. 

<!-- more -->

### Which are the best technologies?

Programming languages are tricky to learn, and programmers have a vested interest in believing that the technologies they know best are the most appropriate technologies to use for every task. For the purposes of this article, those people will be known as _curmudgeons_. 

Curmudgeons often avoid learning more than their one favourite language. I spent about 8 years programming exclusively in C++ before I finally took the jump to another language, and that point represented a refreshingly great learning curve for me. I love C++ but there's features that it simply does not have, so I'll demonstrate by talking about C++ from a curmudgeonly perspective.

C++ does not have reflection, and I used to (and still do) think that reflection can make code hard to understand and follow. However reflection is valuable during application bootstrapping for stringing together components at the highest level using dependency injection containers, for example.

C++ does not have garbage collection. I believe languages that use GC tend to make managing resources other than memory (locks, databases, etc) difficult, which in turn makes a lot of code difficult to deal with. However dealing with certain problems _without_ GC can be very tricky or even impossible - typically anything where the lifetime of an entity cannot be easily identified at coding time, such as lambdas with closures, or ['persistent' data structures](http://en.wikipedia.org/wiki/Persistent_data_structure) (a la [clojure's data structures](http://clojure.org/data_structures)), or often many other situations in multi-threaded applications. 

C++'s standard libraries are incredibly low-level (you'd look long and never find the word 'web', 'service' or 'actor') and the standard is _incredibly_ slow moving (only recently got threading support, lambdas or regular expressions!) However this is a side-effect of the fact that the language is intended to be long-lived, clearly something it's been very successful at.

{% pullquote %} 
So while I believe the functionality of these 'friendlier' languages are often misused or are considered to solve problems they do not in fact solve well, I also know first-hand how awesome they can be in certain specific scenarios. I now believe that {" there are no crappy technologies - only situations where technologies are perhaps not applicable "}. 
{% endpullquote %} 

Need super high performance? C or C++ is great if you know it really well, as an explicit goal of the language is that all features should come at no hidden cost, which is often a detriment to the language's simplicity. If you or the majority of your team is not familiar with the language however, it will probably not go well. If you are writing a large application, or need to quickly pump out a web service or componentised application, it simply might not be the right tool for the job. 

It might be surprising but there are an equal number of curmudgeons using newer languages such as Java, JavaScript and Scala as well. While C++ curmudgeons will tell you that high-level facilities offered by new generation languages (GC etc) are not truly useful, higher-level language curmudgeons will tell you that the performance of their tools are equal, or somehow better than, lower-level languages. Actually, from the perspective that a well-maintained application tends to run smoother this is sometimes true. However from the truest apples-to-apples sense this is rarely the case. 

As an example, an often-cited comparison is that between garbage collecting heap allocated memory and the typical semi-manual approach taken by C++. The argument comes down to the observation that scheduled mass-collection of heap memory is generally more efficient than many individual object heap de-allocations. But many programmers that rely on garbage collection would not be aware of stack-based allocation (the default in C++, unavailable in Java) which offers effectively free memory allcation and de-allocation. Or custom allocators, which are a kind of ad-hoc custom garbage collection which can also offer similar benefits in specific circumstances.

A smart programmer would believe that if a language was created, still exists and has a large user base, it probably has a good reason to be around. A programmer that understands more languages is almost by definition more well equipped to effectively tackle more varied problems.

### What's the difference between Analysis and Design?

Many programmers don't separate the notion of analysis from design. In fact, it would be less charitable but more realistic to say that most programmers don't fully know what analysis is for.

The first step in any project is to understand the requirements - a process that requires a very thorough analysis phase. A thorough analysis will capture all requirements in a language comfortable to the client, create a domain model that the client agrees captures all of the concepts (entities, events, roles, etc) in the system, and give a good representation of the scope that is being tackled (a complete list of actors interacting and their useage scenarios the application will satisfy.) If you tackle a problem without this knowledge, you don't fully understand the problem and therefore are not yet qualified to fix it. 

{% pullquote left %} 
The agile principle of avoiding 'big design up-front' leads people to avoid performing full analysis up front, which is very misguided. {" Every requirement accurately captured represents a significant amount of effort saved "} in large refactorings, or worse yet continual effort working around poorly designed systems.
{% endpullquote %} 

Analysis is important and should be done as completely as possible, lest the wrong application get built. Design is incremental but continual. While analysis documents tend to be fairly static and only change if the actual requirements change, design documents are often not useful much past the development of the code they relate to. For this reason they're usually only used for reasoning about and communicating a plan of attack for an upcoming component being created or worked on. 

### Have we estimated enough time?

Estimation is said to be the hardest part of programming. It _is_ fricken hard. But usually it becomes much more approachable once the complete scope has been explored - if every piece of functionality to be delivered is decomposed into the smallest deliverable increments that the client can verify (often known as user stories in agile terminology), and these dozens or sometimes hundreds of stories can be individually and honestly estimated, a rough estimate may be reached. 

More importantly however, when you find yourself part-way through stories of a project, you have the ability to re-evaluate your estimate of the remaining portion based on how long the first bit took. This process should replace all these 'double and add your grandmothers age' type estimates, though they require some bravery both on behalf of the developers and the business people.

As a bonus, if the stories were separated into must-, should-, and might-haves, a certain amount of flexibility is built into the system where the portion to be delivered becomes negotiable based on revised estimates. 

### Have we completed our design?

Every time I design a new component I go through a few steps. I find that these are often not considered when estimating the time required to implement new functionality.

- most importantly, for every entity in the system **consider how the entity will change over time** - it's simple to represent an order in an online shopping system, but what if it gets cancelled or amended? What if the user account is deleted? What if an item is recalled by the manufacturer?
- **how will the new component be administered and configured?** This means APIs and user interfaces, which are not glamorous but need to be made.
- when modeling the major entities, **model all incoming commands and events** as well - a good way to tell if there's an event missing is if two entities are relating directly to each other. This also yields heaps of other benefits (see [event sourcing](http://martinfowler.com/eaaDev/EventSourcing.html) for example).
- **separate each entity from the value data associated with that entity.** Entities have identity and usually a long lifetime, and are changed many times throughout their life. Values can be compared trivially, serialised and deserialised and are thread-safe by virtue of being immutable facts.

These topics are actually huge but these most readily to mind, expressed as minimalistically as I thought possible. 

### Is UML necessary?

This concept might be a little anachronystic these days as I don't see many people jumping on the UML bandwagon anymore - if anything it's swung the other way, which is no better really. But it can seem sometimes that UML is some kind of all-or-none proposition.

Many treat UML as a kind of _process_, when in fact it is a collection of _languages_. And like any language, it is there to be used primarily for communication. It makes little sense to have a process that revolves around UML per se, but I find that certain diagrams are arguably the best way to express certain ideas. 

<u>_During analysis_</u>: **use-case diagrams** are great for outlining scope; **domain models** are fantastic for discovering the main concepts in a system and are great to carry to early client meetings; and **state diagrams** can _really_ save a lot of time later on down the line (entity states are deceptively tricky to discover.)

<u>_During design_</u>: these are totally situational, but **component diagrams** show how all the services and applications hang together, where message busses are and how high-availability and how other such architectural concerns are handled; I often find myself sketching out **class diagrams** aplenty to provoke discussions on my immediate plans; and I email tons of **sequence diagrams** around indicating the intricate details on how components coordinate their interactions.

In all, UML is neither good nor bad, it is a set of tools you may decide to use when communicating about software. Objecting to them on principle is like objecting to the written language on principle.

### Will Design Patterns save us?

There are a lot of good books out there detailing a lot of good design patterns. These patterns take many forms but there is a common unifying factor of all of them - they don't actually do anything by themselves (otherwise they'd be applications or services.) They can be very useful for two purposes - describing the design of a system to others, or reason about how a part of a problem might decompose into a set of entities, values and relationships. 

The problem comes in when the design patterns book comes out as the first step in creating a new application. No matter the problem, the first step should always be to understand the problem through _analysis_, and then the first step of design should be something like figuring out the major components in the system or the data in/out and transforms, depending on the situation. The design patterns emerge from this process, and the books are useful for recognising them, not guiding the design process.

Interestingly, design patterns are more important to imperative languages than declarative ones - imperative languages are by their nature higher level and the abstractions that design pattern books enumerate tend to fall out much more naturally without a lot of effort. Functional language curmudgeons are oft quoted as saying that design patterns are missing language features. I'm not entirely convinced of this perspective, but it does show how genuinely powerful those languages are at expressing high level concepts simply.

