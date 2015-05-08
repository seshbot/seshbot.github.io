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

__I really wanted to write about things I learned with OpenGL that I found difficult to research but realised that my first stumbling block was figuring out the versions__

== OpenGL is a crufty and confusing mess

OpenGL in its various incarnations spans almost 20 years and at least 7 major revisions, including the embedded versions. Anyone looking to learn to use OpenGL will face a constant battle with finding relevant documentation and samples for their chosen version on their chosen platform with their chosen extensions. 

OpenGL does not work out of the box! An annoying truth is that OpenGL realistically requires supporting libraries in order to function, most importantly to create a context within which the rendering operations can work.

On the other hand, it is an open standard that has been very widely adopted and so is the defacto standard for developers wanting a powerful low-level intrinsics that work on many platforms. Extensions allow vendors to quickly and flexibly add functionality, but multiple vendors introduced similar yet incompatible extensions creating confusion around which to use.

== OpenGL versions and extensions

after 2 no large architectural changes - mainly better performance and more generally useful aspects of existing functionality. extensions available but not generally available so focus more on the base version capabilities

OpenGL 1 - high level, slow
 - Immediate mode only (fixed function pipeline)
 - no shaders
 - a lot higher level, simpler
 - slow and deprecated
 - a lot of people still use this when demonstrating functionality
 - supported by Windows

OpenGL 2 - shaders!
 - first shader-based version
 - vertex and fragment shaders

OpenGL 3 - a massive controversy, was going to fix state problems but abandoned
 - geometry shaders
 - new shader language
 - deprecated most 1.0 functionality (immediate mode stuff) introducing compatability and core modes
   - compatability mode gives access to the old fixed function pipeline
   - core mode does not

OpenGL 4 - perf and professional
 - 4.0 - D3D 11
 - tesselation (introduce extra polygons for smoother curves) and compute shaders
 - modern OSX 4.1
 - 4.5 - D3D 12 http://arstechnica.com/information-technology/2014/08/opengl-4-5-released-with-one-of-direct3ds-best-features/
 - Direct State Access - mitigate above problems with immediate mode ()
 - GPGPU shader - SPIR (basis for vulcan) - intermediate language based on LLVM

ES
 - OpenGL ES 1.0 based on OpenGL 1.3
 - OpenGL ES 1.1 based on OpenGL 1.5
 - OpenGL ES 2.0 based on OpenGL 2.0
   - WebGL is based on this
   - Google ANGLE (rendering on Windows)
 - OpenGL ES 3.0 full subset of OpenGL 4.3
   - supported by modern iOS and Android devices

Vulkan - GLNext, totally redesigned, fantastic!
 - get away from immediate mode single-threaded global state context heritage
 - allow shaders to be written in a variety of languages
 - http://arstechnica.com/gadgets/2015/03/khronos-unveils-vulkan-opengl-built-for-modern-systems/

TODO: glsl versions

extensions provide access to functionality not standard in a version, but are not reliably available across platforms. Its difficult to recommend using extensions if you dont have a set list of platforms on which to test their availability.

broadest availability, learner functionality

== Challenges you will face

support libraries
creating a context
Cross platform support
Debugging GL state in different platforms
multithreading correctly is extremely difficult - just dont do it!
extensions
state management - cannot write optimal abstractions because cannot encapsulate state (unnecessarily setting state always), state querying is prohibitively expensive

 - lots of problems: http://richg42.blogspot.jp/2014/05/things-that-drive-me-nuts-about-opengl.html

== Who should learn OpenGL

If you just want to get some sprites on the screen, be it 2D or 3D, you should probably not be learning OpenGL. OpenGL is a low-level library that takes a long time to learn, and getting it to work across platforms is terribly difficult.

== Most important concepts

Context
 - platform specific stuff (WGL, EGL, GLX specs)
 - kind of rendering parameters (should use depth testing? clear colour, blending type)
Coordinate system
 - device normalised coordinates
 - 3D coordinates (model, view, projection - will describe in 3D section)
 - directional vs positional vectors (w coord)
Shader concepts
 - primitive (http://www.ntu.edu.sg/home/ehchua/programming/opengl/images/GL_GeometricPrimitives.png)
 - vertex
 - fragment
 - binding data to communicate between GPU and client (CPU)
   - programs, uniforms, attributes, varyings, buffers (vertex and element/index, depth, stencil, colour data), textures, samplers, framebuffers (depth, stencil, colour), vertex array objects
Linear algebra (magic!)
 - matrix operations (basic - multiplication, advanced - inverse, transpose...)
   - note: matrix mult combines operations but is not reflexive - last operation performed first
 - perspective/ortho transforms
Lighting
 - fragment color terms - diffuse, specular, ambient, emmissive
 - lambertian lighting model, goruroud, phong

== Getting Started

Khronos C headers

Libraries to use:
 - context creation (e.g., GLFW or GLUT)
 - linear algebra (e.g., GLM)
 - extension loader (e.g., GLEW)

Documentation
Read the specs

Create context
Graphics loop (depending on context library)
Create shaders
Render primitives
 - pass data to shaders
    - pushing vertex buffers (plus other vertex info) into the pipeline
    - shaders, compiling, invoking and VAOs
    - Vertex Array Objects (VAO). VAOs store all of the links between the attributes and your VBOs with raw vertex data..
            GLuint vao; glGenVertexArrays(1, &vao); glBindVertexArray(vao);
            As soon as you've bound a certain VAO, every time you call glVertexAttribPointer, that information will be stored in that VAO. This makes switching between different vertex data and vertex formats as easy as binding a different VAO!
    - setting shader variables (uniforms attribs)
    - element buffers
 - invoke appropriate draw call
 - eg: http://stackoverflow.com/questions/21980947/replacement-for-gl-position-gl-modelviewprojectionmatrix-gl-vertex
Enable a 'check for errors' mode
Debugging OpenGL

tutorials
 - http://ogldev.atspace.co.uk/index.html
 - http://www.opengl-tutorial.org/beginners-tutorials/
 - http://open.gl/introduction modern, GLSL 1.5
 - info shaders: http://notes.underscorediscovery.com/shaders-a-primer/
    - simple shader tutorial : http://www.opengl.org/sdk/docs/tutorials/ClockworkCoders/
 - source examples https://github.com/progschj/OpenGL-Examples

== Upcoming

 - basic doing 2d stuff
   - setting gl environment (depth buffer)
   - basic coords
   - drawing primitives
   - simple texture
   - ortho
 - basic 3d
   - setting gl environment
   - 3d coordinate system (plus MVP, normal matrix)
   - drawing primitives
   - perspective
 - 3d lighting
 - 3d shadows
 - texturing (texture ID, sample uniform ID, texture unit), sampling, alpha discard, stencil
    - http://stackoverflow.com/questions/9224300/what-does-gltexstorage-do
 - multi pass rendering (FBO)
   - Render scene -> FBO -> texture colour buffer -> screen rectangle -> post effect frag shader -> screen
   - post processing
 - loading models and animations
 - rendering text
 - Qt
 - Picking