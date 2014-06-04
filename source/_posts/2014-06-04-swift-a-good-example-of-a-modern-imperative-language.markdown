---
layout: post
title: "Swift: a solid modern imperative language"
date: 2014-06-04 08:25:06 +0900
comments: true
categories: Languages OSX
keywords: "Swift,OSX,language" 
---

_Note 1: these are first impressions only - I've only spent a day really looking at the docs and playing with the XCode beta so I am probably mistaken about some stuff_

_Note 2: I am using a beta of XCode, and it has caused me some trouble (a mysterious service it starts keeps crashing, filling my HDD up with core files.) I would recommend waiting for the non-beta if I were you._

Apple recently announced the support of a new language targeted at the same application programming space as Objective C. It's called Swift and it seems to me a very good summary of the features all modern imperative languages are striving for. 

The last decade or so has seen a strong resurgence in functional programing evangelism. Languages like F#, Scala, Clojure and even Erlang for a while re-introduced to mainstream programmers high-level concepts that imperative programmers were largely unfamiliar with. A short experiment with a language supporting algebraic data types, type inference, higher order functions, closures, or the standard foundational map, reduce and fold functions will convince any programmer that their language
would be far better off being more declarative. 

For a comprehensive guide to the Swift language see the [Swift tour](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html).

{% img /images/upload/2014-06-04-swift-xcode6.png "Some Swift code in Xcode 6 beta" %}

I have wanted two write another iOS app for a while now, and so I'm thinking Swift may be the way forward for me there. To that end I've spent all this morning going through docs and messing with XCode to get a feel for the various idioms and coding styles it encourages... 

<!-- more -->

## Syntactic niceties

Swift is a very much streamlined language, and for low friction it seems to take a lot from F#. Like F#, a programmer can seemingly almost approach swift as a scripting language - the first line in your source file can be functioning application code, no boilerplate required! And the 'playground' concept is very familiar to anyone who has used Scala Workspaces or F# interactive mode. 

The clarity of syntax is quite impressive - type inference introduces ```var``` and ```let``` common to many modern languages, and bracket-less control flow operations and optional semicolons make your code look a lot cleaner (and a bit like golang).

Structure types may be initialised in-line at the point of instantiation: ```val vga = VideoMode(width: 800, height: 600)```. Once you see this you think _of course, why would it be otherwise?_

Syntactically there is a lot of shorthand available for interacting with fundamental data types:
``` csharp
// create an Array[Int]
var xs = [1, 2, 3]

// create a Dictionary<String,Double>
var menu = ["Coffee": 3.5, "Bacon": 5.1]

// create a tuple of two strings
var location = ("Tokyo", "TYO") 

// shorthand for iterating over Sequences
for x in xs { println("x is \(x)") } 
```

And anyone who loves Scala's string interpolation operators will appreciate the ability to write ```println("hi, my age is \(me.age - 5)")```. 

As a special treat, Swift also supports Objective-C style named parameters. This can make some functions arguments more clear when they have the same type:
```
func replace(inString str: String, #value: String, #withValue: String) -> String {
  // ... 
}

// then later call it:
val simplified = replace(inString: url, value: "http://", withValue: "");
```

OK perhaps that is not a great example, but I think the concept has a lot of merit.

## Functional concepts

In addition to type inference and closures, Swift has obviously been checking out the Scala and F# and the like for ideas, much to its credit. 

First, fret not because higher-order operations are all available to you, and included in the standard library are standard set of foundational functions you'd expect in a functional language such that it is possible to write ```var ys = map([1,2,3], {i in i * 2})```.

But one thing that seems quite interesting to me is the extended syntax available to enumerations (known as 'associated types') that make them almost seem like *algebraic data types*...
``` csharp
enum Shape {
    case Circle(Double)
    case Ellipse(Double, Double)
    case Square(Double)
}

func area(s : Shape) -> Double {
    switch (s) {
    case .Circle(let radius): return 3.14159 * radius * radius
    case .Ellipse(let min, let maj): return 3.14159 * min * maj
    case .Square(let width): return width * width
    }
}

area(Shape.Circle(10))
```

...plus, if you add a new value (say, Rectangle) to the enumeration the ```area()``` function will fail to compile, as the compiler will complain that the switch _must_ be exhaustive. Take that scala!

Tuples can be *pattern matched* using placeholders, bound parameters and _where_ clauses, which is a fairly awesome thing:
``` csharp
switch (bounds) {
   case (0, 0): println("zero bounds!")
   case (0, _): println("x == 0")
   case (_, 0): println("y == 0")
   case let (x, y) where x < 0 || y < 0: println("invalid bounds!")
   case let (x, y) : println("bounds are [\(x),\(y)]")
```

There is no true currying though of course it can be simulated by having functions return other functions - garbage collection + closures means that you can create generators along the lines of:
``` csharp
func makeGenerator(increment: Int) -> () -> Int {
    var x = 0
    return {
        x += increment
        return x
    }
}

var gen = makeGenerator(10)
for var n = 0; n < 100; n = gen() {
    println(n) // prints 0, 10, 20, 30...
}
```

_On a side note, Scala's currying leaves a lot to be desired, as does it's support of ADTs - one must explicitly make structures a _case class_ before you get functionality approaching an ADT._

*Optional types* are also supported in the library but also with nice syntactic sugar. The ```?``` operator defines an optional type (similar to C#) and also allows operations on that type to be optionally unwound. The ```!``` operator forces unwinding, and causes an error if the optional type is not set. 

Also, there is some fancy syntax for switching on an optional type:
``` csharp
struct Job {
    var  title: String
}
struct Person {
    var name: String
    var job: Job?
}

// create a person with no job!
var paul = Person(name: "Paul")

if let title = paul.job?.title {
    println("you are a \(title)!")
}
else { // fallthrough because there was a nil optional
    println("you have no title!")
}
```

_Note: this doesn't currently compile - the current XCode 6 beta does not compile the samples provided by the documentation. I'll leave this here though because it still captures the intent of the optionals feature_

Notice how the ```if`` resolves the expression as false because the ```?``` operator did not resolve.

I haven't even touched on a few other cool features like ```@lazy``` annotation, generics, variadic parameters, or the myriad ways closures can be specified (it turns out ```{$0}``` is a valid closure, with inferred argument and return value!)

## OO niceties

I'll describe some features based on where I find them most familiar from:

- *C#* - ```struct``` and ```class``` types. Classes are reference-counted (see below) while structs have value semantics (are destroyed automatically.) 
- *C#* - extensions and computed properties remind me of C# _extension methods_
- *Objective-C* - _Automatic Reference Counting_ (ARC) provides a kind of semi-manual garbage collection. Essentially whenever you set a reference type to ```nil``` it will be collected. (The language also supports weak references.) This system is similar to using ```shared_ptr```s in C++ in that you can end up with circular references, but unlike C++ there don't seem to be any automatic scoping facilities that relinquish resources as they move out of scope. I might be wrong about this. 
- *Objective-C* - Swift supports the notion of _protocols_ for polymorphic behaviour
- *?* - Object identity can be compared (i.e., are these references to the same object?) using the ```===``` operator. 

## Does it go far enough?

In many ways this is a fairly conservative language - Swift is clean and nice to use, and I think would make a good replacement for Objective-C, but most other modern languages are focusing on higher level concepts that don't seem to be getting a showing here.

The main thing that comes to mind is the lack of language features to help out with thread synchronisation and concurrency. Other languages are focusing on lightweight thread-like structures or coroutines, asynchronous actors or asynchronous computation expressions/monad type syntax (think F# ```async {}```.)

This is the first release of this language and I think some initial conservatism might be sensible. Typically I think compiled and C-based languages have preferred to put new functionality into libraries and only reluctantly add keywords and syntax to the existing base language. On the other hand, other languages (C# 5, F#, Haskell) have shown that without syntactic sugar (like ```async { }```, ```do { }```, ```yield``` and the like) it is seemingly implausible to make async-friendly code look super readable and imperative, avoiding what is often known as _callback hell_.

So here's hoping this project keeps the steam it's started off with.

## Do we need another language?

Swift is certainly more approachable than Objective-C, which I very much appreciate. Apple have always been quite good at providing an environment where different languages interoperate seamlessly, so there really seems no downside - if you have a lot invested in Objective-C you can still leverage all your previous work with Swift, or presumably use other peoples swift libraries in your own Objective-C applications. 

There will always be curmudgeons of course, but they should be ignored. The lengths that some will go to to justify not having to learn new concepts is always amazing to me, especially when doing so is the best way to progress in our industry!

Apple takes the development of programming languages quite seriously. They are heading up some of the more interesting additions to new versions of C++, most anticipated (by me) being the 'modules' concept that promise to bring C++ compile times and binary interfaces in line with more modern high-level languages. They play this role of innovator well here because the concepts outlined in their proposal are drawn directly from practical experience in implementing said features in the
Objective C language itself.

