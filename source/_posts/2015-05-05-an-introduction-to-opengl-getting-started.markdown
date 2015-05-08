---
layout: post
title: "An Introduction to OpenGL - Getting Started"
date: 2015-05-05 07:40:37 +0000
comments: true
published: true
categories: [OpenGL, C++, HowTo]
keywords: "OpenGL,C++,OpenGL ES"
description: learning OpenGL
---

_I really wanted to write about things I learned with OpenGL that I found difficult to research but realised that my first stumbling block was figuring out the versions, so this article is a list of all the stuff I knew when I started out. What a daunting task!_

## OpenGL is a crufty and confusing mess - things you should know
The most important thing a programmer should know before deciding whether to learn OpenGL is that OpenGL is very low level, poorly documented and extremely crufty.

The next thing to know about modern OpenGL is that there is very little about it that is inherently 3D. Most functions and implicit state stores primitives capable of describing 3D positions, directions and transformations, sure, but unless you are using OpenGL 1.0 you as a programmer will be responsible for transforming your own application data into screen-space coordinates, and of calculating the exact colour of every pixel on the screen incorporating lighting and shading algorithms that you implement yourself. Fortunately linear algebra conventions make this stuff a lot simpler than it sounds!

{% pullquote right %}
In its various incarnations OpenGL spans almost 20 years and at least 7 major revisions, including the embedded versions. {"Anyone looking to learn to use OpenGL will face a constant battle with finding relevant documentation and samples for their chosen version on their chosen platform with their chosen extensions."} 
{% endpullquote %}

The third immediate concern - OpenGL does not work out of the box! An annoying truth is that OpenGL realistically requires supporting libraries in order to function, most importantly to create a context within which the rendering operations can work. At the least you'll probably be incorporating at least three libraries - one to generate a GL context into which you render, a matrix and linear algebra library, and an extension loader for when you need a little more functionality than your platform provides.

{% pullquote left %}
So why would you even consider it?! Why would you write a series of articles on a technology that scares you so much? The reason it has kept its relevance is because {"OpenGL is the only low-level graphics API supported on pretty much all platforms you'd want to render graphics on."} Because it is so very widely adopted it is still the defacto standard for developers wanting a powerful low-level intrinsics that work on multiple platforms. Extensions allow vendors to quickly and flexibly add functionality, but multiple vendors introduced similar yet incompatible extensions creating confusion around which to use.
{% endpullquote %}

If you are only targeting Windows you might consider DirectX. If you don't need to interact directly with your shaders, and are happy to work at a higher level of abstraction and not with the GPU directly, perhaps a higher level graphics library such as Unity or UDK would work better for you.

## Most important concepts
Here's a bit of a glossary of terms and concepts that are necessary to become familiar with in order to be an effective OpenGL programmer.

### Primitives, Vertices and Fragments
Each time you call an OpenGL drawing function you are drawing a __primitive__. You can think of a primitive as a shape of some kind that can be either 2D or 3D and rendered as a collection of points, lines, triangles or quadrilaterals. 

Primitives are described as a collection of __vertices__. These vertices are passed to the GPU and it then _rasterises_ them into __fragments__. These fragments may be filtered, blended and anti-aliased and ultimately may be drawn as pixels on your screen.

### Model, world, view and device coordinate systems
The OpenGL __coordinate system__ is quite simple - when rendering pixels on the screen, the range of visible pixel coordinates within the view port goes from -1.0 to 1.0 in the X, Y and Z directions. This coordinate space is known as __normalized device coordinates__ or NDC, and anything falling outside of this range will not be rendered. The X and Y coordinates describe the horizontal and vertical component of the pixel (-1, -1 corresponds with the bottom left corner of the view port) and the Z axis is the _depth_ component that is used for depth testing (if enabled.) The Z coordinates move _away from_ the viewer, so +Z is into the screen.

When programming in 2D you can draw simply to the view port using these coordinates. The sample application in this article will draw a primitive using normalised device coordinates directly.

However when programming in 3D (and often in 2D) we don't use NDC directly. 3D models and shapes are often described in what's called __model space__ where, for example, the center of the model might be the (0., 0., 0.) origin and the dimensions of the model might fall far outside of the visible NDC range. In this coordinate system (and all others except NDC) by convention the Z axis moves _towards_ the viewer, so the -ve Z axis is towards the screen. This is known as a right-hand coordinate system for reasons I'll discuss later. DirectX and the NDC use a left-hand coordinate system (Z axis moves away from the viewer.)

As this model is placed in and moves around the virtual world it is translated into __world space__ which has its origin at some arbitrary location (for example, perhaps the middle of the room being drawn.) The transformation that translates, rotates and scales a model coordinate into world space is known as the __model matrix__.

When rendering the world from the perspective of some virtual camera, the objects to be displayed are translated into __eye-space__ or __view space__. In view space the driver is able to do fancy things such as occlusion culling and back-face culling to determine which fragments do not need to be rendered because they are hidden by other objects in the scene or are facing away from the camera. The transformation that translates, rotates and scales a coordinate from world space into view space is known as the __view matrix__.

Next the coordinates are transformed into NDC where the Z axis is flipped and all visible coordinates are squeezed into the -1.0 to 1.0 range on each axis. The transform that moves a coordinate from view space into NDC is called the __projection matrix__. The projection matrix can be used in 3D to change things like the field of view and the near and far clipping planes.

Finally the graphics driver transforms the coordinates to __clip space__ which performs the clipping and an action called a __perspective divide__ and a __viewport transform__ which are not really important at this point.

TODO: coordinate diagram

### Immediate mode and the fixed function pipeline
I discuss this more when discussing the different OpenGL versions below, but OpenGL 1 was much simpler to use than later versions, though much less powerful. OpenGL 1 operated using a _fixed-function pipeline_ using an _immediate mode_ API, where the programmer not only describes high-level primitives' individual vertices but also describe the lighting model to use, define several lights and set up materials to use during rendering. Retained mode allows all of this functionality to be executed on a shader program, which is written by the developer but run on the GPU directly. This is much more performant but requires a lot of extra work on the part of the developer. 

The __context__ encapsulates the rendering view and. A context must be created before rendering may begin, and tracks the current settings the driver will use while rendering such as whether the renderer will perform depth testing and how the renderer will blend non-opaque fragment colours. Contexts are essentially global in scope (unfortunately!) and are the cause of most of the grief people have with OpenGL. They also should be used with great caution in multi-threaded environments.

state management (glEnable/glDisable, current shader/bindings, VIEWPORT)

Unfortunately the creation of an OpenGL context is not defined by the OpenGL spec. If you want to create one you'll either have to look up how to do this on your platform of choice (for example Windows provides WGL, while OSX and Linux systems use GLX) or use another third-party library that does this for you (I like GLFW, but some people still use the older GLUT.)



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
 - dot product (cos angle, projection, dist squared)
 - cross product (perpendicular axis)
 - perspective/ortho transforms

Lighting

 - fragment color terms - diffuse, specular, ambient, emmissive
 - lambertian lighting model, goruroud, phong

## OpenGL versions and extensions
A constant frustration when reading documentation and code examples is that OpenGL 1.0 is _worlds apart_ from OpenGL 2.0. Many of us would have been well served if they had given it a totally different name, so different are the products!

__OpenGL 1__ functions in what is now called _immediate mode_ and is considered deprecated. In this version the programmer describes the scene lights, materials and fog, then notifies the driver of each polygon explicitly. The driver would then render the scene using its own internal lighting model using the described lights and materials. This is called the _fixed function pipeline_.

``` c++ OpenGL 1 example code snippet
// configure light
glEnable(GL_LIGHTING);     // deprecated
glEnable(GL_LIGHT0);       // deprecated
glLightfv(GL_LIGHT0, GL_AMBIENT, {.4f, .1f, .1f}); // deprecated

// draw a primitive
glPushMatrix();            // deprecated
// matrix operations will apply to all vertices until glPopMatrix()
glLoadIdentity();          // deprecated
glRotatef(3.14f, 0., 0., 1.); // deprecated
glBegin(GL_TRIANGLE);      // deprecated
  glVertex3f(.0, .0., .0); // deprecated
  glVertex3f(.1, .0., .0); // deprecated
  glVertex3f(.1, .1., .0); // deprecated
glEnd();                   // deprecated
glPopMatrix();             // deprecated
glFlush();
```

__OpenGL 2__ introduced shaders, yet still provided compatability with the above described model. Shaders had access to the state declared in the fixed function pipeline through standard global variables (such as the `gl_LightSource[]` array and the `gl_FrontMaterial` variable sent from the client and the `gl_ModelViewProjection` matrix which was generated by the driver.) The vertex shader can invoke the standard fixed-function pipeline functionality by callling `gl_Position = ftransform();`.

__OpenGL 3__ compeletely deprecated the immediate mode fixed-function pipeline. Of course this introduced backwards-compatability issues so they also introduced several _profiles_ to allow backward compatability to be optionally compiled in. The _compatability profile_ can be requested to enable deprecated features, while the _core profile_ disallows the use of these features.

Since OpenGL 2 however there have been no truly large architectural changes. Changes have focused around adding features (new types of shaders, for example) to provide better performance and more generally useful aspects of existing functionality. This is a shame because there are still a lot of problems with OpenGL that many developers want addressed - the original goal of OpenGL 3 was to include massive refactorings to remove all the global state (more on this later) but vendors objected so strenuously that this work was put off until _GLNext_ which is now known as [Vulkan](https://www.khronos.org/vulkan).

OpenGL shaders are written in their own language - __GLSL__. GLSL has its own varied syntax between versions, and to make things even more complicated they support the notion of extensions. The best bet is to decide on which version of OpenGL you will be learning and learn the GLSL appropriate to that version. They are all quite similar in form but are syntactically incompatible with each other.

Some mention should be made regarding extensions.  Extensions are often touted as a great feature in OpenGL not available in other graphics libraries such as DirectX. New functionality is often added to OpenGL by vendors as extensions, and then if this functionality proves popular it becomes formalised as part of the API in a later version. 

If you want some functionality not natively available in your chosen version of the OpenGL API you will often find an extension that provides that functionality. The problem is, extensions are not supported uniformly on all platforms with all drivers, so quite often you'll have to work around the missing functionality in some platform anyway. This severely limits the usefulness of extensions, and in general you should try to do without them if possible.

### OpenGL 1 - high level and slow but simple
 - Immediate mode only (fixed function pipeline)
 - no shaders
 - a lot of people still use this when demonstrating functionality
 - latest version natively supported by Windows

### OpenGL 2 - shaders run on the GPU
 - first shader-based version
 - vertex and fragment shaders

### OpenGL 3 - a controversial release, was going to fix state problems but abandoned
 - framebuffers for rendering to non-screen targets (e.g., render to a texture)
 - geometry shaders
 - new shader language
 - deprecated most 1.0 functionality (immediate mode stuff) introducing compatability and core modes
   - compatability mode gives access to the old fixed function pipeline
   - core mode does not

### OpenGL 4 - modernisation, performance and professional enhancements
 - 4.0 - D3D 11
 - tesselation (introduce extra polygons for smoother curves) and compute shaders
 - modern OSX 4.1
 - 4.5 - D3D 12 http://arstechnica.com/information-technology/2014/08/opengl-4-5-released-with-one-of-direct3ds-best-features/
 - Direct State Access - mitigate above problems with immediate mode ()
 - GPGPU shader - SPIR (basis for vulcan) - intermediate language based on LLVM

### OpenGL ES - simplified for embedded systems
 - OpenGL ES 1.0 based on OpenGL 1.3
 - OpenGL ES 1.1 based on OpenGL 1.5
 - OpenGL ES 2.0 based on OpenGL 2.0
   - WebGL is based on this
   - Google ANGLE (rendering on Windows)
 - OpenGL ES 3.0 full subset of OpenGL 4.3
   - supported by modern iOS and Android devices

### WebGL - based on OpenGL ES 2.0

### Vulkan - GLNext, totally redesigned, fantastic!
 - get away from immediate mode single-threaded global state context heritage
 - allow shaders to be written in a variety of languages
 - http://arstechnica.com/gadgets/2015/03/khronos-unveils-vulkan-opengl-built-for-modern-systems/

TODO: glsl versions

extensions provide access to functionality not standard in a version, but are not reliably available across platforms. Its difficult to recommend using extensions if you dont have a set list of platforms on which to test their availability.

broadest availability, learner functionality

### Challenges you will face

support libraries
creating a context
Cross platform support
Debugging GL state in different platforms
multithreading correctly is extremely difficult - just dont do it!
extensions
state management - cannot write optimal abstractions because cannot encapsulate state (unnecessarily setting state always), state querying is prohibitively expensive

 - lots of problems: http://richg42.blogspot.jp/2014/05/things-that-drive-me-nuts-about-opengl.html


### Getting Started

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
 - arc synthesis is gone! pdf here http://www.pdfiles.com/pdf/files/English/Designing_&_Graphics/Learning_Modern_3D_Graphics_Programming.pdf
 - http://ogldev.atspace.co.uk/index.html
 - http://www.opengl-tutorial.org/beginners-tutorials/
 - http://open.gl/introduction modern, GLSL 1.5
 - info shaders: http://notes.underscorediscovery.com/shaders-a-primer/
    - simple shader tutorial : http://www.opengl.org/sdk/docs/tutorials/ClockworkCoders/
 - source examples https://github.com/progschj/OpenGL-Examples
http://learnopengl.com/
'the ryg blog' - graphics pipeline


### Upcoming

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
 - gamma correction
 - multi pass rendering (FBO)
   - Render scene -> FBO -> texture colour buffer -> screen rectangle -> post effect frag shader -> screen
   - post processing
 - loading models and animations
 - rendering text
 - Qt
 - Picking
