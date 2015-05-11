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

The next thing to know about modern OpenGL is that there is very little about it that is inherently 3D. Most functions and implicit state use primitives that are capable of describing 3D positions, directions and transformations, but you as a programmer will be responsible for transforming your own application data into screen-space coordinates, and of calculating the exact colour of every pixel on the screen incorporating lighting and shading algorithms that you implement yourself. Fortunately linear algebra makes this stuff a lot simpler than it sounds!

{% pullquote right %}
In its various incarnations OpenGL spans almost 20 years and at least 7 major revisions, including the embedded versions. {"Anyone looking to learn to use OpenGL will face a constant battle with finding relevant documentation and samples for their chosen version on their chosen platform with their chosen extensions."} 
{% endpullquote %}

The third immediate concern - _OpenGL does not work out of the box_! An annoying truth is that OpenGL realistically requires supporting libraries in order to function, most importantly to create a context within which the rendering operations can work. At the least you'll probably be incorporating at least three libraries - one to generate a GL context into which you render, a matrix and linear algebra library, and an extension loader for when you need a little more functionality than your platform provides.

{% pullquote left %}
So why would you even consider it?! Why would you write a series of articles on a technology that scares you so much? The reason it has kept its relevance is because {"OpenGL is the only low-level graphics API supported on pretty much all platforms you'd want to render graphics on."} Because it is so very widely adopted it is still the defacto standard for developers wanting a powerful low-level intrinsics that work on multiple platforms. Extensions allow vendors to quickly and flexibly add functionality, but multiple vendors introduced similar yet incompatible extensions creating confusion around which to use.
{% endpullquote %}

If you are only targeting Windows you might consider DirectX. If you don't need to interact directly with your shaders, and are happy to work at a higher level of abstraction and not with the GPU directly, perhaps a higher level graphics library such as Unity or UDK would work better for you.

## Most important concepts
Here's a bit of a glossary of terms and concepts that are necessary to become familiar with in order to be an effective OpenGL programmer.

### OpenGL context
The __context__ encapsulates the rendering view, its rendering settings and which OpenGL objects are currently active (such as which shader will be used to render). When starting your application you will need to create a context and set the capabilities you want the driver will use while rendering, such as whether the renderer will perform depth testing, how the renderer will blend non-opaque fragment colours and what part of the window to render into (the viewport). Contexts are essentially global in scope (unfortunately!) and are the cause of most of the grief people have with OpenGL. They also should be used with great caution in multi-threaded environments.

Unfortunately the creation of an OpenGL context is not defined by the OpenGL spec. If you want to create one you'll either have to look up how to do this on your platform of choice (for example Windows provides WGL, while OSX and Linux systems use GLX) or use another third-party library that does this for you (I like GLFW, but SDL2 is very popular, and some people still use the older GLUT.) These libraries often give you access to keyboard and mouse input as well as various other utilities you might need when making your app (such as buffer swapping, text, audio and the like.)

Below is a simple example of creating a context using GLFW in C or C++. For a line-by-line explanation of this see [the official GLFW docs](http://www.glfw.org/docs/latest/quick.html).

``` c++ Creating a context with GLFW
#include <GLFW/glfw3.h>

static void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);
}

int main() {
  if (!glfwInit())
      exit(EXIT_FAILURE);

  // create context (unfortunately GLFW bundles this in with window creation)
  GLFWwindow* window = glfwCreateWindow(640, 480, "Simple example", NULL, NULL);
  if (!window) {
    glfwTerminate();
    exit(EXIT_FAILURE);
  }
  glfwMakeContextCurrent(window);
  glfwSwapInterval(1); // wait for a vsync before swapping to avoid 'tearing'

  // tell GLFW to notify us when keys are pressed (esc will exit)
  glfwSetKeyCallback(window, key_callback);

  // main loop
  while (!glfwWindowShouldClose(window)) {
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);

    // viewport takes up whole window client area
    glViewport(0, 0, width, height);

    // clear the viewport to red
    glClearColor(1., 0., 0., 1.);
    glClear(GL_COLOR_BUFFER_BIT);

    // TODO: draw your primitives here!

    glfwSwapBuffers(window);
  }

  glfwDestroyWindow(window);
  glfwTerminate();

  exit(EXIT_SUCCESS);
}
```

Most OpenGL context management libraries are very similar in usage to this.

### Primitives, Vertices and Fragments
Each time you call an OpenGL drawing function you are drawing a __primitive__. You can think of a primitive as a shape of some kind that can be either 2D or 3D and rendered as a collection of points, lines, triangles or quadrilaterals. 

Primitives are described as a collection of __vertices__. These vertices are passed to the GPU and it then _rasterises_ them into __fragments__. These fragments may be filtered, blended and anti-aliased and ultimately may be drawn as pixels on your screen. So remember, _fragments are not pixels_.

### Coordinate systems
The OpenGL __coordinate system__ is quite simple - put simply, the range of visible coordinates within the view port goes from -1.0 to 1.0 in the X, Y and Z directions. This coordinate space is known as __normalized device coordinates__ or NDC, and anything falling outside of this range will not be rendered. The X and Y coordinates describe the horizontal and vertical component of the pixel (-1, -1 corresponds with the bottom left corner of the view port) and the Z axis is the _depth_ component that is used for depth testing (if enabled.) By default the NDC Z coordinates move _away from_ the viewer, so +Z is into the screen.

{% img center /images/upload/2015-05-09-gl_1_ndc.png "Normalised device coordinates (NDC). By convention XYZ shown as RGB" %}

When programming in 2D you can draw simply to the view port using these coordinates. The sample application in this article will draw a primitive using normalised device coordinates directly.

3D coordinate systems are more complicated and I will discuss them in depth in a later article. For now it is interesting to note two things: first, by convention OpenGL coordinate systems other than NDC generally have the Z axis moving _towards_ the viewer, so the _negative_ Z axis goes into the screen.

Secondly, when rendering 3D primitives the verticies that describe the primitive are usually transformed in between a well defined sequence of coordinate spaces. The coordinates in the model's local __model space__ are first moved to __world space__ where their position and orientation is given relative to all other objects in a scene (some may use the same model, but will look different because they have different model space transformations.) Then the coordinates are transformed to __view space__ where their position and orientation are relative to the viewer's eye. Then they are transformed into NDC coordinates and finally into what is known as __clip space__.  All this will be described later - I just wanted to list the terms here for completeness.

### Shaders and the render pipeline
The render pipeline describes how, every draw call, the verticies in your primitives are passed to your shaders, clipped, rasterised, then blended and otherwise processed into pixels on your screen (or some other render buffer.)

#### Overview
TODO VAOs, glEnableVertexAttribArray and glEnableVertexArrayAttrib

TODO Draw calls glDrawArrays, glDrawElements

To draw a primitive, the GPU first needs your _vertex data_. The GPU will decode your vertex data to extract _vertex attributes_ and pass those into your _vertex shader_ once for each vertex. Your vertex shader is expected to output NDC coordinates for that vertex so the GPU knows where on the screen to show it (if at all,) and information that the GPU should pass on to your fragment shader for fragments derived from this vertex.

Once the GPU has processed all vertices the GPU can clip out all vertices that it won't be rendering and then _rasterise_ the display, which generates a series of fragments which sort-of represent the pixels of the primitive being drawn. The GPU will then call your _fragment shader_ for each fragment, passing it the relevant output data of your _vertex shader_.

You invoke the rendering pipeline by calling one of the `glDraw*` functions (for example `glDrawArrays()`.) Unless you're using the fixed function pipeline you'll have to have a shader program bound. The shader program tells the GPU which vertex shader and fragment shader to invoke. You will also have to specify the vertex data of the primitive you are rendering.

{% uml %}
title Simplified render pipeline

actor "client app"
control GPU

"client app" -> GPU : uniforms\n(glUniform())
"client app" -> GPU : vertex data buffer\n(glVertexAttribPointer())
"client app" -> GPU : invoke renderer\n(glDraw*())

== vertex processing ==

hnote over GPU : extract vertex attributes\nfrom vertex data buffer
GPU -> "vertex\nshader" : uniforms and\nvertex attributes
activate "vertex\nshader"
"vertex\nshader" --> GPU : gl_Position
"vertex\nshader" --> GPU : fragment varyings
deactivate "vertex\nshader"

== vertex post-processing ==

hnote over GPU : clipping etc...
hnote over GPU : rasterise primitives\ninto fragments

== fragment processing == 

loop for each fragment
  hnote over GPU : depth test etc
  hnote over GPU : interpolate frag varyings
  GPU -> "fragment\nshader" : uniforms and\nfragment varyings
  activate "fragment\nshader"
  "fragment\nshader" --> GPU : gl_FragColor
  deactivate "fragment\nshader"
  hnote over GPU : blend fragment
end

boundary FrameBuffer
GPU -> FrameBuffer : fragment data

{% enduml%}


#### Passing data to shaders - uniforms, attributes and varyings
There are two ways your application can pass data to your shaders - _uniforms_ that are set only once per `glDraw*` call and and _attributes_ that may be different per-vertex. In addition, fragment shaders receive per-fragment input derived from the output of the vertex shader in _varyings_.

A _uniform_ represents a variable that remains the same for the rendering of an entire primitive. This might be something like the object material or the position of the sun. Uniforms are set with the `glUniform*` functions (for example `glUniform3f()` will set a uniform of type `vec3` in your shader.) Setting a uniform will make it available in any of your shaders that are want to use it.

An _attribute_ represents data related to the current vertex being processed. Although you can specify vertex data for all vertices in a primitive using the `glVertexAttrib*` functions, you will much more commonly pass a pointer to a buffer of data to be passed into the GPU through the `glVertexAttribPointer*` functions and then tell the GPU how to extract the attribute data from that buffer.

The standard form for using a vertex attribute is something like:
``` c++ setting vertex attribute data
// ... first bind the appropriate shader
GLint position_loc = glGetAttribLocation(shaderProgram, "my_attrib");
glEnableVertexAttribArray(position_loc);
const float vertex_buffer[] = { 0., 0., 0., ... }; // x, y, z positions
glVertexAttribPointer(position_loc, 3, GL_FLOAT, false, 0, vertex_buffer);
glDrawArrays();
glDisableVertexAttribArray(position_loc);
```

##### Sending attribute data buffer to the GPU
There are two ways to send attribute buffers to the GPU - directly pass it in to the `glVertexAttribPointer*` function, and through an OpenGL buffer object.

The `glVertexAttribPointer*` functions take a 

##### Specifying how to extract attributes from buffers
A buffer sent to the GPU is just an opaque block of bytes until you tell the GPU how to extract data from it. To do this you call the `glVectexAttribPointer`

##### Sending per-fragment varyings to the fragment shader
_Varyings_ are per-fragment data the fragment shader uses to calculate the output colour of a fragment. Examples of this might be the normal of the surface at that point, or the material colour interpolated from the material colours of the surrounding vertices. A 3D program will often use this information along with the location of the sun (passed through a uniform) in its lighting calculations - a fragment on a surface directly facing a light source will have a brighter colour than one not.

The calculation of what value is passed into a varying is a little bit tricky. Fragment shaders get their per-fragment input indirectly from the vertex shaders through variables called _varyings_. Of course for any three vertices forming a triangle you could have hundreds of fragments, so the GPU takes the varyings coming out of the vertex shader for each vertex influencing a fragment and interpolates them before passing them into the fragment shader.

#### The Vertex Shader
Below is a simple vertex shader that expects two input variables from the application: the uniform `time` and the vertex attribute `vert_position`. A `uniform` represents 

``` c++ a simple vertex shader
// per-primitive variables passed in from your application
uniform float time;

// per-vertex variables passed in from your application
attribute vec4 vert_position;

// output data to send to the fragment shader for each fragment derived from this vertex
varying vec4 frag_colour;

void main() {
  // mandatory! calculate the NDC coordinates of this vertex
  gl_Position = 0.01 * sin(time) + vert_position;
  // frags go from black on the left side to red on the right side of the viewport
  frag_colour = vec4((vert_position.x + 1.) / 2., 0., 0., 1.);
}
```

vertex shader
rasterisation
fragment shader

The partial application code below shows a basic vertex shader, fragment shader being invoked to render a square in the middle of the window.

``` c++ rendering a 'triangle strip' primitive using a buffer of vertex positions
  // just define our shader in-line
  const char vertex_src[] = "\
    attribute vec4 position; // passed in from application \n
    varying vec4 frag_colour; // passed out to frag shader \n
    void main() {                                          \n
      // this is where we would transform to NDC, but our coordinates are already NDC
      // so just pass the position through as-is           \n
      gl_Position = position;                              \n
      frag_colour = vec4(.2, .2, .2, 1.);
  }";
  const char fragment_src[] = "\
    varying vec3 frag_colour; // passed in from vert shader (and interpolated) \n
    void main() {                              \n
      // fragment colour is dark gray          \n
      gl_FragColor = frag_colour;
  }";

  // create shaders
  auto vertexShader = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertexShader, 1, &vertex_src, NULL);
  glCompileShader(vertexShader);
  auto fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragmentShader, 1, &fragment_src, NULL);
  glCompileShader(fragmentShader);

  // create shader program using the shaders
  GLuint shaderProgram = glCreateProgram();
  glAttachShader(shaderProgram, vertexShader);
  glAttachShader(shaderProgram, fragmentShader);
  glLinkProgram(shaderProgram);    // link the program
  glUseProgram(shaderProgram);    // and select it for usage

  // we need this to pass the 'position' attribute in to the vertex shader
  auto position_loc = glGetAttribLocation(shaderProgram, "position");

  while (!quit) {
    // ... clear viewport etc 

    // these are the NDC coordinates of a square on the viewport
    static const float vertexArray[] = {
       0.0, 0.5, 0.0,
       -0.5, 0.0, 0.0,
       0.0, -0.5, 0.0,
       0.5, 0.0, 0.0,
       0.0, 0.5, 0.0
    };

    // glVertexAttribPointer allows you to specify vertices in many ways, so its pretty complicated
    glVertexAttribPointer(position_loc, 3, GL_FLOAT, false, 0, vertexArray);
    glEnableVertexAttribArray(position_loc);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 5);

    // ... swap buffers etc
  }
```

### Immediate mode and the fixed function pipeline
I discuss this more when discussing the different OpenGL versions below, but OpenGL 1 was much simpler to use than later versions, though much less powerful. OpenGL 1 operated using a _fixed-function pipeline_ using an _immediate mode_ API, where the programmer not only describes high-level primitives' individual vertices but also describe the lighting model to use, define several lights and set up materials to use during rendering. Retained mode allows all of this functionality to be executed on a shader program, which is written by the developer but run on the GPU directly. This is much more performant but requires a lot of extra work on the part of the developer. 

### Linear algebra (magic!)
Linear algebra is the language of graphics programming. You _need_ to learn some basics if you're going to tackle this stuff. I won't go into what a vector or matrix is here but you will have to learn the basics of their form and function if you don't already know them.

The most basic understanding you should have is that vectors are usually used to describe coordinates in space and directions, and matricies are used to describe transformations (translation, scale, rotation, shear etc) to those vectors. Another thing to note is that a single matrix may represent an accumulation of many different transformations performed in sequence, so if I said (in pseudo-code) `auto m = translate * scale * rotate`, then any time I multiply `m` by a vector it will have the same effect as performing all of those transformations at once - amazing!

Once again, the OpenGL API does not help you in dealing with matricies or vectors, but there is a great supporting library that does - [GLM](http://glm.g-truc.net/). 

There are two ways the elements in a matrix may be stored - OpenGL programmers often use _column-major_ matrix layouts. This is a convention only, but is generally used in the official documentation in the GLM library. The reason this is important is that unlike scalar multiplication, matrix multiplication is not _reflexive_, meaning `A * B` does not equal `B * A`. The main impact of using column-major vs row-major matricies is the order of multiplications must be reversed to have the same effect. In column-major (the most usual) you would accumulate your transformations to the left, so if you want to first rotate (R) then scale (S) then translate (T) last, you would execute `T * S * R`. More typically, the _model view projection_ matrix would be accumulated as `mat4 mvp = P * V * M`.

Vector operations are even more interesting. A few things I want to point out here are dot product, cross product and the difference between positional coordinates and directional coordinates. 

The __dot product__ operation (sometimes known as the _inner product_) is used for many purposes; the dot product of two vectors A and B is a scalar number that is the sum of the products of their components (e.g., `auto a_dot_b = A.x * B.x + A.y * B.y + A.z * B.z`). It turns out that this simple formula gives you the cosine of the angle between those vectors multiplied by their magnitudes (`|A||B|cos(Ɵ)`), which is really useful because:

 - if the vectors are unit vectors (they each have magnitude of 1) the dot product will just give you `cos(Ɵ)` which is a number between 0 and 1, where 0 implies that they are perpendicular to each other (at 90 degrees) and 1 implies they are parallel. This is great for calculating how much light should bounce off a surface if the light direction is one vector and the surface normal is the other.
 - if the vectors are both unit vectors you can inverse cos the dot product to find the angle between the vectors (`auto angle = acos(dot(A, B))`)
 - you can find the projection of vector A onto vector B by finding the dot product of A and B then dividing the result by the length of A.
 - calculating the dot product of a vector with itself will give you the distance squared. If you are checking to see which vector is longer, you can just compare their squared distances (saving you a square root operation)

TODO dot product diagram

The __cross product__ is another simple formula that gives you a vector that is perpendicular to two given vectors. In other words, if you have vectors A and B that both lie along the same surface, calculating `cross(A, B)` will give a vector that represents the normal to that surface. (Note: you will usually want to normalise your normal before using it!)

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

I have chosen to do most of my experimentation in OpenGL ES 2. This should give me the broadest platform availability as well as being compatible with WebGL for web demonstrations. I have resorted to using a few extensions that are supported on the platforms I use where necessary (e.g., to get anti aliasing), though I try to avoid this where possible.

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


 - binding data to communicate between GPU and client (CPU)
   - programs, uniforms, attributes, varyings, buffers (vertex and element/index, depth, stencil, colour data), textures, samplers, framebuffers (depth, stencil, colour), vertex array objects

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
