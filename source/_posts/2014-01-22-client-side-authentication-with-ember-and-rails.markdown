---
layout: post
title: "Client-side authentication with ember and rails"
date: 2014-01-22 09:30:27 +0900
comments: true
published: true
categories: [Rails, Ember, HowTo]
description: client-side authentication using ember.js and rails
keywords: "authentication, ember.js, rails, ruby, devise"
---

_This post follows on from the previous post [creating and deploying a rails + ember app from scratch](/blog/2014/01/15/creating-a-rails-plus-ember-app-from-scratch/). In that post I created a basic ember application being served from rails. Here I'll be adding user authentication to the application I created using the 'edge template' option I discussed, which uses the 'ember-rails' gem to establish the basic connectivity._

I do not want to implement authentication and authorization myself. It is tricky to get right and tends to cause huge damage when it goes wrong in production. 

So I have spent at least three full days looking at various solutions I can build into my simple Ember/Rails application and spent a lot of time experimenting.

This post describes my current understanding of authentication for web applications, and the approach I used to implement a basic authentication system I put up on heroku at http://seshbot.herokuapp.com

If you want to see the source code, have a look at https://github.com/seshbot/new-ember-rails-app

{% img center /images/upload/2014-01-22-seshbot-login.png "Oh jeez I already forgot my password" %} 

_NOTE: this is very text-heavy because after three full days I decided not to spend too long on this blog post. Therefore there are no images at this time. I may update it later to have some nice UML or screenshots, but that time is not now._

<!-- more -->

## Learning the basic concepts

I found a few very detailed introductions to client-side authentication with ember which helped me through all stages of implementation of my system. I highly recommending going through the following resources and comparing the different approaches' overlaps and differences. I also got a lot of value out of re-visiting them after I finished implementing my own solution, because it made me think about some of the trade offs I had made.

### Watch these awesome client-side suthentication videos

http://www.embercasts.com/ covers the client-side concepts of authentication with Ember in [part 1](http://www.embercasts.com/episodes/client-side-authentication-part-1) and [part 2](http://www.embercasts.com/episodes/client-side-authentication-part-2) of their 'Client Side Authentication' videos. Specifically:

- client token authentication concepts
- sending auth request to the server and saving the token (in a 'login' controller)
- setting up controllers
- catching 'unauthorised' error responses and redirecting to login pages
- keeping a sane workflow so the login transitions the user back to their original page
- storing the auth token in local storage so page refresh doesn't reset it _(note: I used cookies instead of local storage)_
- preventing the unauthorized server request if client knows it doesn't yet have a token

This doesn't cover the server side, or anything to do with Rails or any other authenticating server specifically - he used a home-grown demonstration Node.js server for the demonstration. Also doesn't specifically cover authorization (I can see users but can't see their emails for example.) The ember front-end polish in there is all nice though, and I found it very helpful to revisit these videos after I had a basic system in place, in order to add nice error messages and improving the 'view page/redirect to login/return to page' workflow.

### Read about SimpLabs' experience making Ember.SimpleAuth

SimpLabs wrote a [blog post](http://log.simplabs.com/post/57702291669/better-authentication-in-ember-js) detailing their experiences getting ember authentication to work sensibly and according to the various standards.

They wrapped this functionality up in an ember plugin called [Ember.SimpleAuth](https://github.com/simplabs/ember-simple-auth) (and wrote about [how to use it](http://log.simplabs.com/post/63565686488/ember-simpleauth)). There's even a [demo rails app](https://github.com/ugisozols/ember-simple-auth-rails-demo) that uses it.

### Follow the very detailed ember-auth + devise tutorial

Someone else has written a rails plugin called [ember-auth](https://github.com/heartsentwined/ember-auth-rails) that presumably takes care of both sides (rails server and ember client) of the problem. The true value for learning is in the [demo application's tutorial](https://github.com/heartsentwined/ember-auth-rails-demo/wiki) however, which covers:

- setting up your rails app
- setting up devise for rails
- modeling the server entities and API endpoints
- writing tests for all of the above
- setting up your ember app
- creating front-end UIs for authentication with ember

It also has a separate page that goes into [security concerns](https://github.com/heartsentwined/ember-auth/wiki/Security) that highlights a few best practices to keep in mind that frameworks will probably not implement for you:

- always use https
- authentication checks in the client are a convenience only and should never replace auth validation in the server
- do not use the 'current user' ID when retrieving priveleged resources (i.e., don't use client-provided data when performing authorization related functionality)
- never store any credential information in cookies - generally just store the server token, which is expendable
- do not rely on the client framework alone to clear caches etc when logging out - ember data for example doesn't offer a way to clear the data store 

### A few other side-notes while we're talking theoretical

[ember-beercan](https://github.com/kristianmandrup/ember-beercan) seems to explore a different approach that I don't really like, but does have some interesting information on using rails and devise on the server side that I might look at later.

A general concern to keep in mind is that for security reasons if the client-side application is not running on the same url/port as the server application the browser might refuse to let them communicate. In this case apparently you should add Rack::Cors to your app (haven't looked into that yet.)

There is also a lot of discussion around whether the client side should be involved at all in the auth negotiation, and perhaps leaving that up to a separate set of pages served by the server, and the server refuse access to the app at all until that time. This makes the client app much simpler as it can always assume that the user is authenticated (see stack overflow questions [how to access store from app object](http://stackoverflow.com/questions/19401087/ember-js-how-to-get-access-to-store-from-app-object), [session cookie based auth with rails and devise](http://stackoverflow.com/questions/19414393/ember-js-session-cookie-based-authentication-with-rails-and-devise).)

When looking into server-side authentication information I found [this description of a simple hand-rolled solution](http://www.robertsosinski.com/2008/02/23/simple-and-restful-authentication-for-ruby-on-rails/) to be quite helpful, because it is quite short and covers only the rails side.

## What we want from an auth system 

A minimal authentication system should provide:

- _create user_: an interface for creating users
- _login user_: an interface for authenticating a user based on username or email address and password
- error handling: the interface should provide nice handling for errors (if there's an error message it should be printed nicely)
- allow session to persist for some amount of time so the user doesn't have to log in every time they come back

In addition however, we want the system to provide authrisation:

- separation of user roles (administrators, regular users, guests/unauthenticated users)
- authorisation of access to server resources - the server should send a _401 unauthorized_ response to unauthorised requests
- sensible UI workflow for logging in and unauthorised access attempts
  - when a server responds with a 401 response, the UI should take the user to the login screen
  - after login, the user should be returned to a sensible page, possibly based on what they were trying to achieve before being redirected to the login page

Of course the system has to follow industry practices and where possible use well-established technologies to offload all the dangerous stuff like dealing with passwords and hashing.

## Building an Authenticating app

I spent a _lot_ of time experimenting with the various options, generally with little success. The executive summary is that most high-level plugins are generally not production ready, or don't work well together with the latest versions of other parts of the architecture. I ended up following a great tutorial on how to hand-roll your own authentication framework in Ember and Rails, using only a single bcrypt Rails gem for the password stuff. 

### Failed attempt 1: ember-auth-easy Rails gem

I was quite hopeful when I found [ember-auth-easy](https://github.com/mharris717/ember-auth-easy) which was made to work with [ember-auth-rails](https://github.com/mharris717/ember_auth_rails) to provide a full Rails backend/Ember frontend token based authentication solution.

Unfortunately as with so many things in Rails these days, lots of stuff doesn't work with lots of other stuff if you're trying to use the latest versions of things. The devise rails integration was found to be lacking for some reason and there was some mass change involved that broke backwards compatability, and many slightly older gems don't seem to work well anymore. I think it was made to work with Rails 3 as well (I'm on Rails 4.)

In addition, there's a whole lot of gems up there and I'm starting to get pissed off at having to learn 5 new buzzword-riddled technologies for every one new one I learn. 

Before I decided to abandon it I created the following steps (I write it here in case I decide to go back to it later)

```bash Rails Trying to install ember-auth-rails on Rails
vim Gemfile
# add the following: # gem 'ember_auth_rails', :git => git://github.com/seshbot/ember_auth_rails.git
# gem 'ember-data-source', '>= 1.0.0.beta.3', '< 2.0' # ember-data not yet out of beta
# gem 'emblem-rails', '~> 0.1' # easier to write templates
# 
# gem 'ember-auth-rails', '~> 5.0' # client-side authentication
# gem 'ember-auth-request-jquery-rails', '~> 1.0' # auth requests via jQuery.ajax
# gem 'ember-auth-response-json-rails', '~> 1.0' # responses in json
# gem 'ember-auth-strategy-token-rails', '~> 1.0' # token authentication
# gem 'ember-auth-session-cookie-rails', '~> 1.0' # use cookies
# gem 'ember-auth-module-ember_data-rails', '~> 1.0' # ember-data integration
#
# gem 'devise'

vim config/application.rb
# add "require 'devise'" to bottom

bundle install # install new gems
bundle exec rake ember_auth_rails_engine:install:migrations
rails g devise:install
bundle exec rake db:migrate

```

### So I hand-rolled my solution

I eventually found a great post called [authentication with ember.js](http://coderberry.me/blog/2013/07/08/authentication-with-emberjs-part-1/) by a dude who seems to really know what he's talking about. It seems to be a culmination of several weeks of work, and a collaboration with a few other developers. It also includes a link to [Rails::API](https://github.com/rails-api/rails-api), which I really want to use in the future.

The Rails server in the tutorial provides an API that allows creation of a new user, authenticates a user/password combination, and provides admin information to authenticated users. The rails implementation code consists of:

 - router exposes a _user_ resource (for creation and reading) and a _session creation_ post route
 - `user` model is composed of multiple `api-key`s - when the model is loaded, it will create a new api-key if there are no remaining active session keys
   - the `user` model also invokes the [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password) security method that provides an _authenticate_ method (this is built into the Rails framework and uses the bcrypt gem)
 - `api-key` model is composed of an _access token_ and an _exipiry time_
 - all controllers have access to an _ensure_authenticated_user_ function that searches for an active API session key that is associated with the current _HTTP_AUTHORIZATION_ HTTP header
 - the `user` controller allows an unauthenticated client to show or create a new user record, but requires an authenticated session to show all users
 - the `session` controller (invoked via HTTP _post_ from the _session creation_ route) provides _login_ functionality (session creation)
   - first it looks up a `user` associated with the given username or email
   - it then invokes the user object's _authenticate_ method with the given password
   - if either of these steps fail a HTTP 401 response is returned, otherwise a 201 response with the user's _session API key_

In the implementation provided in this system, the notion of a _session_ is not actually stored anywhere in the server - it is merely an access point to a secure token associated with an `api-key` the user has (a new `api-key` is created if the session creation request is valid but no current active session key is available.)

An interesting thing I noticed while re-reading the [SimpLabs blog post](http://log.simplabs.com/post/57702291669/better-authentication-in-ember-js) I mentioned previously is that this scheme does not allow a user to delete their _access token_ from the server at all. Logging out just means clearing the token cookie - if the user re-authenticates the server will just dish them out the same token. If I extended the logout action to clear the token from the server however, all of the user's sessions would become invalidated, so I'd have to change the scheme to create new access tokens for every separate login. I'll leave it as is for now and have a think about it.

As with all other ember things, the instructions were written with a prior version of ember and so don't work anymore. I had a bit of fun getting it working but a couple of things to keep in mind:

 - use latest version of bcrypt
 - use 'jquery-cookie-rails' gem
 - demo uses the [Rails::API](https://github.com/rails-api/rails-api) gem instead of creating a whole Rails application with views etc. Because I previously used the _ember-rails_ gem I didn't do this
- retrieving data from the store is done differently now - see the ember docs
- accessing the store from anything other than a router can be difficult. I get it with this hackery: `var store = GameTableServer.__container__.lookup('store:main')` (see http://stackoverflow.com/questions/19401087/ember-js-how-to-get-access-to-store-from-app-object)
  - TRICK! another problem - store returns an async promise, so you need to wait for that! god dammit. `var self = this; store.get(...).then(function(user) { self.set('apiKey', ...)})`
- if something doesn't seem to be working, keep an eye on your browser's javascript console, net traffic and your rails logs (in heroku you can do this with `heroku logs` or something)

You can have a look at the app as it currently stands (as of Jan 2014) on [seshbot.herokuapp.com](http://seshbot.herokuapp.com). If you're reading this much after Jan 2014 however it probably wont be there any longer. 

### Alternative: Use 'devise' gem directly

[Devise](https://github.com/plataformatec/devise) seems like a very mature and comprehensive rails 'authentication solution' that seems to handle a lot of authentication related problems out of the box in a very configurable way. It takes care of a lot of stuff like sending password reset emails, locking accounts after failed validations, connecting to various auth providers, and lots of other stuff. I will probably end up moving towards it if I ever make an app that warrants that kind of thoroughness.

I found a pretty useful comment on stack overflow that [details how to get it running quickly with Rails 4](http://stackoverflow.com/questions/16513066/devise-with-rails-4) - not sure if thats more useful than the docs. 

I started following [this very detailed tutorial](https://github.com/heartsentwined/ember-auth-rails-demo/wiki) on using rails + ember + devise and found it very useful. Again, I couldn't get things working well together and had to abandon it. If I were to revisit I might also consider following these [very detailed instructions on devise + ember](http://avitevet.blogspot.com.es/2012/11/ember-rails-devise-token-authentication.html).

### Alternative: Use SimpleAuth for client-side stuff

SimpLabs' [SimpleAuth](https://github.com/simplabs/ember-simple-auth) (discussed in [this SimpLabs blog](http://log.simplabs.com/post/63565686488/ember-simpleauth) and mentioned previously in this post) looks pretty cool, and is recently very active. It is still v0.1.0 so I'd prefer to keep away from it for now, but if I wanted OAuth integration (to have a 'login with Facebook' or whatever) I might look into using this for the client-side code.

## My current conclusion

It is laughable that Ember and Rails are in such states of flux that it was easier to hand-roll a solution (although based on a very detailed set of instructions!) than it was to use existing gems and plugins. I hope that changes in the future.

If I ever decide I want a more complex auth solution using rails and ember, I'd probably look at using devise for the Rails side and SimpleAuth for the ember side. I would expect a lot of heart-ache along the way though.
