---
layout: post
title: "Making an Ember.js Web Application"
date: 2014-01-03 22:37:09 +0900
comments: true
categories: 
published: false
---

I have only ever created 'thick' applications - generally compiled C++ apps, often in your typical two-tier client/server architecture. As a regular lurker in [Hacker News](http://ycombinator.com) however, I am often led to believe that web applications are where the action really is. Clearly there's a significant selection bias there, but I have nevertheless been long interested in trying to create something dynamic, globally available and multi-tiered.

TODO: backend + frontend

- http://coderberry.me/blog/2013/07/08/authentication-with-emberjs-part-1/
- nobackend: http://nobackend.org/solutions
- auth with deployd: https://github.com/awc737/emblog
  - prob with deployd: https://groups.google.com/forum/#!msg/deployd-users/VsOU6Vzgg4w/mOTHAtjogQIJ
  - use custom RESTSerializer normalize and serialize for data munging: https://stackoverflow.com/questions/20410016/transform-json-to-an-appropriate-format-for-restadapter-emberjs
  - maybe http://fortunejs.com/ instead?
  - others listed at http://discuss.emberjs.com/t/the-ideal-backend-for-serving-json-to-ember/2460/7

- example game! http://www.solitr.com/blog/2012/02/mvc-design/

TESTING: 
 - install ember plugin for your browser
 - use postman for post queries

express library?
deploy to joyent?

### Front-end UI in Ember.js

TODO: mess with pixi.js

TODO: learning curve:

- watch intro video: application, routes (app, etc, nesting), views/templates (placemarker, etc, utilities linkto etc), controllers (linking to views)
   - later watch again (bound helpers, safe strings, partials, redirect hook/transitionTo, post updates to model)
- data binding (fixture, Ember.Object, Ember Data, Ember Model) arrays etc
   - ember data: https://www.openshift.com/blogs/day-24-yeoman-ember-the-missing-tutorial
- controllers decorate a model (singletons vs instances?) 'needs'?
- Server API
   - munging server data
- template vs view
- route renderTemplate() vs render vs view vs partial vs component
  - components are for reusable elements
     - can pass bound parameters, bound to 'this' by default, but can also be used as a 'block' with 'yield' keyword injecting the custom block
     - can send actions as well
- application adapter

TODO: how does ember work:

- single page (uses hash anchor tag links to avoid reloads - can use history api http://eviltrout.com/2013/06/19/adding-support-for-search-engines-to-your-javascript-applications.html)

debugging:
http://www.akshay.cc/blog/2013-02-22-debugging-ember-js-and-ember-data.html

- index routes (displayed when no sub routes are active, available on every route)
- route vs resource

helpers:
 - block helpers all start with a `#` (if, each, block components)

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

