---
layout: post
title: "GLpp and the case for a new C++ OpenGL wrapper"
date: 2015-03-11 00:51:55 +0800
comments: true
published: false
categories: [C++, OpenGL]
keywords: "C++,OpenGL,GLpp"
description: GLpp is a simple type-safe C++ OpenGL wrapper library
---

I created GLpp to try to address what I thought were the main problems with OpenGL - the plethora of versions and extensions, a lack of type safety and a lack of guidance with important related operations such as context and resource management.

There are many C++ libraries targeted at helping devs deal with OpenGL (such as SFML or Ogre3D) but they often do this by hiding the OpenGL implementation details. This often means that you lose access to shaders, buffers and other implementation details.

GLpp is not a framework - it is a series of libraries that make working with OpenGL simpler. Below the fold I'll outline what I see as OpenGL's main weaknesses and describe my approach to addressing these weaknesses.

TODO: code sample
TODO: https://github.com/hpicgs/glbinding https://github.com/hpicgs/glbinding/blob/master/CMakeLists.txt

TODO: wget https://cvs.khronos.org/svn/repos/ogl/trunk/doc/registry/public/api/gl.xml

TODO: GENERATION PROB:
      - returned enums are not in groups (e.g., GL_FRAMEBUFFER_COMPLETE) but ARE in feature 'required'
        - GL_TEXTURE0 etc should be in TextureUnit but there is no such group (see glActiveTexture)

TODO: abstractions must provide full functionality - must be complete

<!-- more -->

### First, the case for OpenGL
You're interested in creating a graphics-intesnsive application, what would you use? There's a lot of great high-level libraries out there for making games and such, and even HTML these days has a lot going for it with the new HTML5 canvas. If you want to create an interactive 2D demo for the web or mobile platoforms perhaps Processing is for you. If you want to get started with games programming with an accessible programming language (C#), a rich ecosystem of assets and a large community Unity would be a good option. If you wanted something similar for C++ you should consider the Unreal Engine (UDK).

If performance is important to you and you are comfortable with C++ you might consider a native C++ application, but this is not where C++ shines. If you want a complete 2D package (user input, text rendering, etc), consider using Cinder - it appears very well thought out and has been proposed (by Herb Sutter I believe) as the model of a new standard library built into the language itself!

But if hard-core 3D programming is what you want you might then go on to consider a dedicated 3D library. OpenGL is a ready candidate in this space as it is an open standard that is available across many different platforms. But it comes with a complex legacy and a whole lot of technical baggage. 

I wanted to use OpenGL but was amazed at the barriers to entry presented to beginners. The standards are complex and often incompatible with each other, and the documentation is not accessible in the modern sense.

### OpenGL's weaknesses
 - many incompatible versions implemented inconsistently
   - immediate mode...
   - choose a single version that has the broadest support
   - only that version's commands and enums (plus extensions) in the library
 - lack of type safety
   - strongly typed enums (C++11 style)
   - bitfield helper
 - a dependence on third party libraries to solve related problems (context and resource management)
   - should be able to download and start going
   - hide stuff behind init() function
   - symbol problem, DLL solution
 - state management
   - TODO, but a good start?
 - error handling
   - TODO, but a good start?

TODO: link to OpenGL problem discussions

### Auto-generating the wrappers
The Khronos group publishes a registry that describes the complete OpenGL API (TODO: link). From what I can see this is largely used by extension loaders such as GLAD. The registry details the platform-specific types, the enumeration values, enumeration groupings, commands, and which enumerations and commands are required by each API version (called a 'feature') and each extension. 

The `gl.xml` file details these in a _largely_ consistent manner (there are a few rough edges however!) 

Type-safe enumerations can be safely cast to the underlying GL types because they are carefully implemented with compatible underlying types. (TODO: example). 

Bitfields

extension loader. I could have gone the extra few steps and created my own extension loader but discovered that the GLAD approach is very similar to my own, and I could basically just use their files as a drop-in replacement for my own. 

Windows and ANGLE - extension loader 

### Higher level operations provided as library
