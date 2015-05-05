---
layout: post
title: "An Introduction to OpenGL - Getting Started"
date: 2015-05-05 07:40:37 +0000
comments: true
published: false
categories: [OpenGL, C++, HowTo]
keywords: "OpenGL,C++,OpenGL ES"
description: learning OpenGL
---

== OpenGL is a crufty and confusing mess

OpenGL in its various incarnations spans almost 20 years and at least 7 major revisions, including the embedded versions. Anyone looking to learn to use OpenGL will face a constant battle with finding relevant documentation and samples for their chosen version on their chosen platform with their chosen extensions. 

OpenGL does not work out of the box! An annoying truth is that OpenGL realistically requires supporting libraries in order to function, most importantly to create a context within which the rendering operations can work.

On the other hand, it is an open standard that has been very widely adopted and so is the defacto standard for developers wanting a powerful low-level intrinsics that work on many platforms.

== OpenGL versions and extensions

1.X
 - Immediate mode only (fixed function pipeline)
 - no shaders
 - a lot higher level, simpler
 - slow and deprecated
 - a lot of people still use this when demonstrating functionality

2.X
 - first shader-based version
 - vertex and fragment shaders
 - WebGL is based on this

3.X
 - geometry shaders
 - new shader language
 - deprecated most 1.0 functionality (immediate mode stuff) introducing compatability and core modes
   - compatability mode gives access to the old fixed function pipeline
   - core mode does not

ES
 - OpenGL ES 1.0 based on OpenGL 1.3
 - OpenGL ES 1.1 based on OpenGL 1.5
 - OpenGL ES 2.0 based on OpenGL 2.0
 - OpenGL ES 3.0 full subset of OpenGL 4.3
   - supported by modern iOS and Android devices


== Challenges you will face

support libraries
creating a context
Cross platform support
extensions
state management

== Who should learn OpenGL

If you just want to get some sprites on the screen, be it 2D or 3D, you should probably not be learning OpenGL. OpenGL is a low-level library that takes a long time to learn, and getting it to work across platforms is terribly difficult.

== Most important concepts

Context
 - platform specific stuff (WGL, EGL, GLX specs)
 - kind of rendering parameters (should use depth testing? clear colour, )
Shader concepts
 - primitive vs vertex vs fragment
 - binding data to communicate between GPU and client (CPU)
   - programs, uniforms, attributes, buffers (vertex and element/index), textures, framebuffers (depth, stencil, colour), vertex array objects
Linear algebra
 - matrix operations (basic - multiplication, advanced - inverse, transpose...)
 - perspective/ortho transforms
Lighting
 - fragment color terms - diffuse, specular, ambient, emmissive
 - lambertian lighting model, goruroud, phong

== Getting Started

Libraries to use:
 - context creation (e.g., GLFW)
 - linear algebra (e.g., GLM)
 - extension loader (e.g., GLEW)

Create context
Graphics loop (depending on context library)
Create shaders
Render primitives
 - pass data to shaders
 - invoke appropriate draw call
Enable a 'check for errors' mode
Debugging OpenGL
