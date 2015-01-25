---
layout: post
title: "C++ trick: Use Make without Makefiles"
date: 2014-06-16 01:23:57 +0000
comments: true
categories: [C++, tricks]
keywords: "C++,make,linux"
---

I use CMake personally because managing Makefiles is a hassle. However, I still use ```make``` regularly for one purpose: to easily create quick apps without setting up any projects or infrastructure at all. I have no idea where I first heard about this trick, and I can find very little referring to it on the internet. I recently found out that most people didn't know about it though, so I thought I'd put a bit of info up here so others can benefit from it.

Generally when using C++ in an IDE it can be a hassle to create a small test application for, say, verifying a new language feature works the way you think it does, or creating a test bed to create a self-contained but complicated algorithm. In such cases, when I am using an OS that supports ```make```, I generally do this:

```bash
vim blah.cpp
# write your small app
make blah
# make magically runs 'c++ tmp.cpp -o tmp'
./blah
```

... and that's it. It turns out ```make```, when no makefile is present, will try a bunch of stuff that includes searching for ```.c``` and ```.cpp``` candidate files for generating your target. If the target (in this case 'blah') ended instead in ```.o``` it would sensibly generate an object file without linking it into an executable!

There is no easy way to make it automatically detect dependencies and include them, so all your source has to be within that one file. But there are some further tricks you can do...

## Compilation options

By default on my OSX at the moment, make will call my CLang compiler:
```
echo "int main() {}" > tmp.cpp
make tmp
# c++ tmp.cpp -o tmp
```

But without any special flags, CLang will compile without C++14 support, which I really want!

An easy workaround to this is to set your ```CXXFLAGS``` environment variable that contains the flags you always want to be passed to your C++ compiler by default. In my machine I have added to my ```~/.bash_profile``` file: ```CXXFLAGS='-std=c++1y -stdlib=libc++'```. Now when I run this command I get: 

```
make tmp
# c++ -std=c++1y -stdlib=libc++    tmp.cpp   -o tmp
```

Thats pretty cool. Of course you can set any of make's [implicit variables](http://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html) to ensure your app is built with these flags by default. For example, the compiler can be changed to GCC by setting ```CXX=gcc```. 

You can also include default include paths and libraries to link against, so that your small apps are able to incorporate boost or even your own library that you are developing. 

