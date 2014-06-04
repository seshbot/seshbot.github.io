---
layout: post
title: "Week in review: Porting to Qt/QML with OpenGL"
date: 2014-05-16 09:56:26 +0900
comments: true
categories: WeekInReview C++ Game
keyworkds: C++,Qt,QtQuick,QML,OpenGL
description: porting my game to Qt with OpenGL
---
_So I took a month holiday, and got out of the habit of writing blogs... hopefully this will break the dam, it's not like I don't have a billion things to write about_

_Initial version only! I will add pics soon_

Over the last many weeks I have been ploughing through a whole lot of new stuff I've never used before. As mentioned in my last post I decided to up the graphics a bit, but specifically I wanted to figure out a system for a extensible UI for menus and other 2D overlays, and 3D or pseudo-3D graphics. Creating a decent UI controls library I have learned is very difficult (if kind of fun to be honest.) Making something that is flexible enough to automatically layout your controls in a sensible way where everything resizes based on the
content contained within is a very difficult problem that nobody should have to re-solve in this day and age. So I wanted to re-use one that I also wanted to learn for myself. 

In order to add these to my existing framework I took on the (it turns out) monumental task of learning OpenGL and integrating it with Qt/QtQuick/QML.

So far things are looking OK, but I have found the learning curve greater than I'd originally anticipated - OpenGL in particular is a rabbit warren of deprecation and messy global state idioms. That said, I currently have:

- the UI menu/control system is entirely QML based and very simple to extend and use
- the game terrain is constructed using [PolyVox](http://www.volumesoffun.com/polyvox-about/) because I wanted to avoid having to figure out mesh generation along with all this other stuff
- the OpenGL shaders incorporate basic lighting and not much else

The main value I've gained is a fairly decent understanding of what it takes to create modern OpenGL applications (though how useful that knowledge is in this day and age I am not sure.) I have not tried porting any of this across to Windows yet (I've written it all in OSX) but hopefully the fact that I'm using entirely cross-platform technologies will help a little there - though Windows is known to have very dodgy OpenGL support so I suspect that will be the cause of most of my porting
troubles.

<!-- more -->

## The Qt Stack

I've always been interested in [Qt](http://qt-project.org/) - I don't know of any more highly polished user interface libraries for C++ out there, and they've been producing really interesting technologies out that seem like they were created by people who actually understand C++. As a developer who opted to buy in to the Microsoft WPF UI framework, I find the QtQuick and QML libraries to be thoroughly refreshing and intuitive.

QML is a clean and simple markup language for writing user interfaces in a declarative fashion. The most apparent advantages over WPF for me were that the syntax is not XML based and that the property bindings may be declared in javascript, within which any properties are automatically dynamically bound so that property updates are detected and cascade automatically through the entire scene graph. In addition to that, the C++ to QML binding mechanism entirely leverages the Qt
metadata system that they've tooled out and honed over the last more-than-a-decade, so everything just seems to work!

### QML basics 

Here's a simple QML example:

```javascript Simple QML example
import QtQuick 1.0

Rectangle {
   width: 200
   height: 200
   color: "blue"

   Image {
      source: "pics/logo.png"
      anchors.centerIn: parent
   }
}
```

C++ QML components are essentially just regular C++ classes that use the Qt metadata system to expose properties, signals and slots - there really is no special QML magic required. These types are exposed to the QML engine through a single C++ commmand `qmlRegisterType<MyCoolControl>("com.seshbot", 1, 0, "CoolControl");`. This can then be consumed from within your QML by first `import com.seshbot 1.0` and then declaring your `CoolControl { }` just like the `Rectangle` in the above example.
All properties declared in the C++ class are immediately available from within QML - any changes made from the QML file will automatically call your setters, and any updates from within your C++ class will automatically propogate out to the QML file. MAGIC!

### QML with OpenGL

As of Qt Quick 2.0, QML internally uses OpenGL to do all its own rendering so rendering your own OpenGL should theoretically not be too difficult. In fact, check out this [awesome demo](https://www.youtube.com/watch?v=P4kv-AoAJ-Q) of a guy messing with an OpenGL shader in QML in real time. In the end however it took a few weeks to iron out, largely because this technology is pretty new and still has some kinks, and is not well documented yet (at least the stuff I wanted to do.)

There are three ways I know of putting your OpenGL content into a QML scene:

- create a custom Qt control that does all the OpenGL stuff internally and include that control in your `QtQuickView`
- extend `QtQuickView` and do the OpenGL stuff in its constructor
- rendering your OpenGL to a frame buffer and having Qt inject that into its own layout. This is what [Ogre integration](http://advancingusability.wordpress.com/2013/03/30/how-to-integrate-ogre3d-into-a-qt5-qml-scene/) does, but I haven't explored this

There's not much difference between the two approaches - I went with the second because creating a control that is invoked from QML raises questions of how you inject your game state into the view. I wanted to just pass my game data into the constructor.

The Qt libraries come with an example called 'Scene Graph - OpenGL under QML' that I found very helpful.

I did encounter a few problems:

- the QtQuick Controls library (which provides native-looking controls you can use in your QML files) don't seem to work with OpenGL versions older than OpenGL 4. After consulting the Qt guys on their IRC channel (#qt-quick on freenode) I [filed a bug](https://bugreports.qt-project.org/browse/QTBUG-38817), so hopefully it will be addressed in future versions. 
- my specialised QtQuickView class (that renders my game in the background under the QML stuff) didn't want to render any of my immediate mode OpenGL code - this is probably OK because immediate mode has been deprecated since version 1. (more on OpenGL versions and immediate mode and such in the future!)
- all of the demos use older versions of OpenGL (probably to minimise compatability issues on Windows) so I had a bunch of surprises when I tried modernising it (basically had to learn each version of OpenGL as I progressed)

The Qt quick guys are on the #qt-quick IRC channel around 9pm japan time by the looks, so that's generally the best time to get live help if you need it.

## OpenGL

My god, OpenGL is a mess. Each version of OpenGL (there are 4) seemed to deprecate the old way of doing things and introduce entirely new idioms:

- OpenGL 1 was all about 'immediate mode' because there were no shaders yet. You just tell OpenGL (in your C++ code) where the primitives and lights are and it takes care of all the rendering details
- OpenGL 2 introduced the GLSL shader language for writing 'vertex' and 'fragment' shaders. This was a huge step forward in performance because you pipe all your vertex data into the graphics card in one go, but it meant that you have to do all the lighting and model/view/perspective transformations yourself in the shader. This makes it a lot harder to pick up for newbies. 
- OpenGL 3 totally messed with the GLSL syntax, and added the notion of vertex buffer objects (VBOs) which I found out are _mandatory_ to use although nothing will warn you if you do not use them. Things just wont show up. Also there is a new type of shader - the 'geometry' shader.
- OpenGL 4 introduced the 'tessellation' shader. I have no idea what that does yet as I have not started down the OpenGL 4 road.

In addition to this, Windows only natively supports OpenGL 1, because they follow their whole DirectX thing. You can ask your users to upgrade their video drivers, or you can use an OpenGL -> DirectX translation layer to get around this problem (Qt apparently offers optional compatability via Googles [ANGLE](https://code.google.com/p/angleproject/) library.)

Plus, any platform may support any number of 'extensions' which provide capabilities on top of the 'core' functionality offered by that OpenGL version. A good application will check the availability of all extensions they are using, which seems like a massive hassle to me at this point. Theres a library called the GL Extension Wrangler (GLEW) thats supposed to help with this, and Qt has its own set of helpers to ensure that youre only able to invoke functionality thats actually provided by
your chosen GL version. 

Oh, there are also the 'embedded' versions of OpenGL - OpenGL ES. These are apparently much smaller and well supported so I think I will migrate towards using some OpenGL ES version in the near future - probably OpenGL ES 2.0, which is supposed to be compatible with OpenGL 4.1 I believe.

In general I'd say stay away from writing your own graphics drivers at this level - use higher level stuff that abstracts your OpenGL vs DirectX decisions from you. I went with OpenGL because I was suffering the delusion that it would make my experience with my QML layer simpler, but looking at the incompatabilities and weird differences between platforms I can see a lot of trouble in my future if I continue down this route. 

I plan to write a more thorough map of the path I took through this so that hopefully others do not have to make the same mistakes I did. 

## PolyVox voxel mesh generation

I didn't want to also have to figure out how to generate meshes for my game at this point, so I decided to go with a library that allows the easy generation of voxel meshes. 

PolyVox is actively being developed by a couple of pretty smart guys. A lot of it has the feel of a university thesis project, but it seems to work quite well, which is the most important thing. Most helpfully for me, they seem to be writing their examples using Qt in Windows and Linux, so I can learn from their mistakes with OpenGL on Windows (something I'll have to do soon.)

I plan to try generating some models in Blender and use something like [AssImp](http://assimp.sourceforge.net) to import them into my game soon. 

## General application design

I really want to put my stuff on github but I'm finding myself a bit recalcitrant on that front, because its still got so much half-baked experimental stuff in it. I will push myself to do it soon however because I'd like to link to parts of the code when writing these blog posts. 

It was somewhat satisfying to realise that all of the changes and work I've done in the last couple of months has had no effect on the core modules I established for the 2D version of my game. All the terrain and entity management, along with the core module message passing mechanisms have remained the same. 

I spent some time discovering an intuitive way to describe my 3D scene for rendering in OpenGL (i.e., for encapsulating all the OpenGL buffers, shader programs and shader program attribute bindings.) Of course this has been done many times before but OpenGLs 'stateless' approach (or whatever they call having to bind your objects to global state) makes this a challenge. 

The fundamental types in my scene description are:

- `camera` encapsulates the perspective and view matrices (mapping world-space coordinates to pixels in the view). This has a `render()` method which tells the `scene` to render itself using this camera's view data
- `scene` contains all the entities and light data that may be rendered into the view, as well as the active shader program. The scene invokes each `entity`s `render()` method
- `entity` encapsulates a `model` that is to be rendered as well as the model matrix which maps the mesh from local 'model coordinates' into the world coordinates, oriented the correct way and all that jazz
- `model` encapsulates all the buffers and VBOs required to render a mesh

My system is also pretty dynamic - changes to the shader program files on disk immediately cause the application to re-compile and start using the new shader in the application, which helps speed things up on occasion. 

