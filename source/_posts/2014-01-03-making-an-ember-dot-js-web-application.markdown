---
layout: post
title: "Making an Ember.js Web Application"
date: 2014-01-03 22:37:09 +0900
comments: true
categories: 
published: false
---

I have only ever created 'thick' applications - generally compiled C++ apps, often in your typical two-tier client/server architecture. As a regular lurker in [Hacker News](http://ycombinator.com) however, I am often led to believe that web applications are where the action really is. Clearly there's a significant selection bias there, but I have nevertheless been long interested in trying to create something dynamic, globally available and multi-tiered.

### Front-end UI in Ember.js

TODO: mess with pixi.js

Two great resources are the [ember naming conventions](http://emberjs.com/guides/concepts/naming-conventions/) which explain how the application routes, controllers and templates are looked up for each request, and the [ember getting started guide](started/adding-a-route-and-template/), which is a step-by-step basic tutorial.

Note that I experimented by manually creating a small application, but would probably use yeoman (see the end of the section) in practice when creating real applications. 

Following the getting started guide we have the following...

{% include_code ember-headers.js %}

{% include_code verbatim ember-demo-step1.html %}

Route: 

- `App.Router.map()` to map URLs to specific routes
- App.XXXRoute = Ember.Route.extend() (where XXX is the CamelCase name of a template) maps the request to a model
- `<script  type="text/x-handlebars" data-template-name="xxx">` (where 'xxx' is the snake-case name of the route) renders the model in handlebars markup.
- hierarchical mapping (under resource specification, specify child routes)

Model:

- App.MyEntity = DS.Model.extend()

Views (templates)
To allowing updates:

- extend a controller
- wrap control structures with 'itemController' tags, to which template input fields will be bound
- `{% raw %}{{output}}{% endraw %}` helper designates an area of a template that will dynamically update as we transition between routes.

Controller
Templates specify a controller, to which form actions will be dispatched. Controller implements additional functions which are invoked by name - free standing for accessor functions and under the 'actions' collection for updates. See the [ArrayController](http://emberjs.com/api/classes/Ember.ArrayController.html#method_filterProperty).

fixture or REST application adapter

yeoman to create entire framework (see sketch.js)

### Heroku
http://jasongarber.com/blog/2012/01/10/deploying-octopress-to-heroku-with-a-custom-buildpack

### Yeoman

### Grunt

### MVC Frameworks

Ember.js, Angular

### Utilities

jquery

grunt

require

{% include_code verbatim no-header ember-headers.js %}

