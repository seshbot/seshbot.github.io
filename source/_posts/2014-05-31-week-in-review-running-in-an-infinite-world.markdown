---
layout: post
title: "Week in Review: Running in an infinite world"
date: 2014-05-31 20:24:19 +0900
comments: true
categories: [WeekInReview, C++, OpenGL]
keywords: "C++,OpenGL,OSX,Windows"
---

Here's a quick snap of the 2D SFML client alongside a new OpenGL client: 
{% img /images/upload/2014-05-31-compare.png "SFML client alongside OpenGL client with QML overlays" %}

OK I could have spent a bit longer on the screenshot - I haven't made any models yet other than cubes, and I'm not using any textures, and I should have adjusted the angle and colour of the directional light to make it look like evening or morning or something, to show off some of the immediate benefits of going to 3D.

I did spend some time making the camera zoom in from a map-like view to a chase-cam view:
{% img /images/upload/2014-05-31-zoomed.png "The camera is tethered to the player character" %}

In general however I'm hoping to ramp-down on the OpenGL stuff and go back to working on the core functionality. The last week was actually pretty productive: 
{% img /images/upload/2014-05-31-bugfixes.png "Most recent git checkins" %}

Also I've been spending a fair amount of time in [PicoPico Cafe](http://picopicocafe.com) when it's open, and I'm guessing I'll be spending more time there in the coming weeks as a bunch of construction is scheduled outside my house during business hours when nobody is supposed to be home.

<!-- more -->

## World Building

The 3D functionality in my game so far is provided by a thin layer that invokes the exact same service layer (game, player, mobile and prop unit services) used by the 2D client. I took the time to finally make some extensive refactorings that I've been planning for some time:

#### Infinte Terrain!
The terrain now runs effectively infinitely, in that it can cache any combination of arbitrary regions. The complicating factor was the fact that I want the regions to be stored in a sensible way that provides for really fast lookups many times per second as entities roam around the countryside, even outside of the player's view. More work needs to be done on this to unload cached regions that are no longer relevant.

#### Infinte Entities!
The entity service, responsible for facilitating rapid interactions with many geographically-local entities, can now scale out exponentially more efficiently than before. Entity 'moment' information is stored contiguously in memory for super cache friendly iteration. Unfortunately this encourages the programmer to pre-allocate large portions of memory to allow the number of entities to fluctuate without large re-allocations. 

Because of this obsession with data locality, every region was previously allocating enough space for all entities in the game to coexist at once so I could trivially say `auto moment = entities_[entityId].moment;` (or something kinda like that.) Now I changed it so there is a single ledger shared outside the specific regions with lookup instructions for each entity indicating that entity's region and index within that region. This means that the regions can be much smaller, reducing the region-to-memory relationship from exponential to linear, which is HUGE. (Of course, the old scheme was never meant to stay in there.)

I now have 1,000,000 entities pre-allocated without straining memory or computational resources at all (about 100MB memory for the whole app) whereas before I was settling for about 10,000 lest I run into gigabytes for a game with a relatively small number of regions. 

#### Lots more stuff of course

I also made an interesting change to the core 'entity moment' structure so it includes a 'facing direction' as well as the existing velocity vector that indicates which direction and at what speed the entity is moving. I was having trouble determining the direction an entity should face when it is not moving (the velocity is 0,0 so has no implicit direction.) This wasnt a problem when I was rendering all entities as circles. 

## Back to OpenGL 2 again

The more I learn about the troubles people have with OpenGL the more concerned I became about getting my app to work on Windows. Through a fine bit of serendipity I met the always helpful [Greggman](http://greggman.com/) at PicoPico, who was one of the devs who implemented WebGL in Google Chrome. He gave me some great advice that lined up with a few things I'd found on the internet and convinced me to move to OpenGL ES 2.0. 

As I mentioned last week OpenGL support in Windows is lacking due to MS pushing their own DirectX 3D stack. But fortunately Google have written a library called [ANGLE](https://code.google.com/p/angleproject/) that is a 'conformant implementation of the OpenGL ES 2.0 specification that is hardware‐accelerated via Direct3D.' This means that if you write conformant OpenGL ES 2.0 code you get DirectX compliance for free (at least that is the idea.)

Another advantage of OpenGL ES (other than the widespread support, including on mobile devices) is that it is much more stringently standardised. Apparently standard OpenGL does not come with conformance tests of any kind, so vendors don't have a mechanical way of verifying that they have implemented conformant drivers. ES does have such tests however so anecdotally provides a much cleaner integration experience.

Of course I'm effectively going back to OpenGL 2 syntax and functionality which is a bit of a drag, but I wasn't really using geometry shaders or complex alternative rendering pipelines anyway. 

## Object Picking with the mouse

If someone clicks on a pixel on the screen (in pixel coordinates), how do you discover which object they were clicking on? This is deceptively difficult! The old way of doing it involved using a special part of OpenGL called _selection buffers_ that allows you to assign a name to each entity being rendered, and query a pixel for the name of the entity rendered therein. That is deprecated however.

The modern analog of this is a manual process called _colour picking_, which involves rendering identifying values instead of colours to a special buffer that is not rendered. This image can be queried via `glReadPixels()`, the returned result is the identifying value of the object at that pixel. I chose not to go down this route though.

Instead, I chose to do it entirely on the CPU by performing the rendering calculations in reverse, in a process often known as _raycasting_. The rendering process involves taking each entity in your scene and multiply its coordinates by a _model matrix_, then a _view matrix_ and then a _projection matrix_, transforming it into world space, then into camera space, and then into screen space. To figure out what object is at a pixel, I perform these operations in reverse by passing those pixel coordinates to the _inverted_ perspective matrix and then to an _inverted_ view matrix. This gives you the location of a point in
space corresponding to that point on the screen. If you draw a line from the location of the camera through that point, you have a _ray_ into 3D space that is every point behind that pixel! The object picked is the object intersecting with that ray that is closest to the camera (I'm just iterating through every object near the camera for now.)

For more information on this have a look at [this article on raycasting](http://antongerdelan.net/opengl/raycasting.html). I like this because it is purely algorithmic and doesn't require special shader code or anything.

## Qt Quick and OpenGL

I continue to be happy with Qt - they are so active, they're always releasing interesting new tech. It is hard to catch them for feedback but it can be done and when they are on IRC they are very helpful.

Unfortunately the OpenGL support in Qt Quick is still in a great state of flux, so finding the correct way to use OpenGL ES was quite tricky. Turns out however that simply _not_ specifying an OpenGL version, and using the default function pointers their [utility library provides](http://qt-project.org/doc/qt-5/qopenglfunctions.html) is the proper way of using OpenGL ES in a portable fashion, even when your platform does not provide it (it falls back on the 'desktop' 2.0 functions.) 

## Up Next

My representation of the world in the core code is still effectively 2D in that all entities have an _x_ and a _y_ but no altitude component. For rendering purposes that is extracted from the terrain service by the rendering engine for visual effect only. But if I am to allow jumping and have some notion of visual occlusion I will soon have to add a _z_ component to the velocity and the position of each entity. This will also mean that the entity service will need to be dependent on the
terrain service.

I also want to implement a proper day/night cycle and some fancy controls in the GUI, like a slider that allows you to choose the time of day. This will hopefully provide a large ambiance improvement at little cost. 

As far as blogging goes, last week I was intending my next post to be about my adventures in OpenGL and to provide a clear roadmap for others who want to follow the same path I took, but it is such a _huge_ topic, and I am still not certain I have all the facts right, that I have put it off so far. We'll see how that goes...

