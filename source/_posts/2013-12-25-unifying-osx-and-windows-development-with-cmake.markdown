---
layout: post
title: "Unifying OSX and Windows development with CMake"
date: 2013-12-25 15:08:15 +0900
comments: true
categories: [ C++ Development ]
published: false
---

Today I started a new C++ project. I would like to be able to compile this application in Windows, OSX and Linux as I have each of those environments at home and use them regularly. I need a build system that is platform agnostic. 

[CMake](http://www.cmake.org) is a build system generator, meaning it replaces the <code>configure</code> step of the old <code>./configure && make && sudo make install</code> installation idiom.

Ideally, compilation should be as simple as:
<pre>
cd myapp
mkdir -p build    # < --- don't build from the source directory!
cd build
cmake ../ && make && make install
</pre>

I would highly recommend reading the official [CMake Tutorial](http://www.cmake.org/cmake/help/cmake_tutorial.html) to get the basics of creating an application project and creating a library project. This document focuses on the areas I had problems with specifically.

### Creating a library project

### Creating an application project

The application references 

### Finding dependencies

### Creating installers

OSX: Get PackageMaker from https://developer.apple.com/downloads . It's supposed to be packaged with /Auxilary Tools for XCode/, but I think this is no longer the case. 



