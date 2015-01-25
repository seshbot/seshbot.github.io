---
layout: post
title: "Creating and deploying a Rails + Ember app"
date: 2014-01-15 17:54:16 +0900
comments: true
published: true 
categories: [Rails, Ember, HowTo]
keywords: ruby, rails, RoR, ember, heroku
description: Seshbot creates a Ruby on Rails app with Ember.js and deploys it to Heroku
---

Today I decided to wield my new Rails and Ember knowledge and... look into yet another new technology. I thought it would be helpful to have an online app to demonstrate the fruits of my labours, so am deploying a new app to **[Heroku](http://heroku.com)**.

Heroku is an 'application platform' in the cloud, meaning that you can push certain kinds of apps (written in Ruby, Python, Java and Node.js) and it will ensure all the correct infrastructure is in place. When you sign up you get to host one app for free so it's easy to try out.

Later I will probably move to [Amazon Web Services](http://aws.amazon.com), which provides a basic virtual machine in the cloud that you can do anything with. This will allow me to host multiple applications without having to worry about paying money. Heroku _does_ offer some pretty nice scaling, monitoring and deployment tools though (the admin panel literally has a slider to allow you to spin up new application instances.)

This post shows how I went through all steps, including setting up the PostgreSQL database on OSX, creating a skeleton Rails app, and deploying to Heroku. It is a culmination of having gone through several sources:

- much was taken from this useful step-by-step '[Rails + Ember blog post](http://www.devmynd.com/blog/2013-3-rails-ember-js)' and this [follow up post](http://www.devmynd.com/blog/2013-10-live-on-the-edge-with-rails-ember-js) that incorporates changes for newer versions of the frameworks.
- when I got to the part involving installing the 'ember-rails' gem, I found that the [ember-rails documentation](https://github.com/emberjs/ember-rails) was pretty useful.
- some of the Heroku stuff came from the [Heroku Code School lesson](https://www.codeschool.com/code_tv/heroku) summary.

<!-- more -->

## Choosing a database

By default Rails will use sqlite3 for its database, and this isn't by default available in Heroku. As I'm going to have to do some configuration anyway, I might as well choose a nicer database. 

I was deciding between MongoDb and PostgreSQL. MongoDb offers flexibility when it comes to managing file assets in your database, while PostgreSQL is much more well established in existing hosting infrastructures (AWS and Heroku), so can make initial deployment much simpler. Mongo is also more amenable to schema changes because it's a NoSQL schema-less document database, but I think Rails is supposed to make schema changes easy anyway with the various `db:` commands.

As Heroku comes with PostgreSQL support out of the box, for now I'll go with Postgres. I'm as yet not very familiar with Heroku and want to make things easier on myself.

The following installation instructions came from a blog entry on [installing PostgreSQL on OSX with HomeBrew](http://ricochen.wordpress.com/2012/07/20/install-postgres-on-mac-os-x-lion-with-homebrew-howto/):
```bash Installing PostgreSQL on  OSX
# easiest if you have homebrew installed
brew install postgresql

# ensure it starts up when your machine starts
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

# ensure you don't accidentally run the older version
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bash_profile && . ~/.bash_profile

# create a database user for the application to use
# (alternatively you should be able to run 'createuser -d myapp')
psql postgres `whoami`
create role myapp with CREATEDB login password 'password1';
```

_Notes:_

- _the `createuser` command can replace the `psql` command stuff: `createuser -d myapp`_
- _if the DB username is different to the application name (below) you'll need to change the rails configuration later so it knows which username to use_
- _I assume Heroku doesn't require you to manage the database at all_

## Creating a simple Rails app

Creating a Rails app is really simple _once you know the commands_. So from scratch, if you include all the learning involved behind each command, it's actually not very simple. But these steps make it simple for me.

TIPS: I read somewhere that you should always run `bundle exec` before running a rails command to ensure that you're only working with gems in your Gemfile. Technically you could run all the commands below without prepending `bundle exec` however.

```bash Creating the rails application framework
rails new myapp --database=postgresql
cd myapp
vim config/database.yml # set the database username and password, and on OSX un-comment the 'local' setting
bundle exec rake db:create    # create databases
bundle exec rails generate scaffold Thing name:string # generate model/views/controllers
bundle exec rake db:migrate   # update database with model data
bundle exec rails s           # start rails server localhost:3000
```

_Note: I had to uncomment the 'local' setting from my _database.yml_ file because rails couldn't connect due to permission problems on the local socket file. I could have reconfigured postgres instead but meh._

OSX users can also use [POW!](http://pow.cx/) or [Anvil](http://anvilformac.com/) (which uses POW! under the covers) to set up a fake URL pointing to their local rails app directories, so in my case I can visit http://myapp.dev and it will actually show me the app running on my local machine. It makes the testing cycle a lot quicker.

Add some simple static content: 
```bash Generate some simple content in the Rails app
rails generate controller StaticPages home about --no-test-framework

# set root '/' route to point to static home page
vim config/routes.rb # add "root 'static_pages#home'" beneath other routes
```

Now you should be able to visit `localhost:3000` and see a generic 'home' page message.

<!-- x_ -->

### Check in to git

This creates a local git repository, but during the heroku deployment step I'll push it over there too. I'll also push it to GitHub when it looks like more of an app. So in git parlance, this is what I'll have on my local machine:

{% uml %}
database "master"
database "source"
database "heroku"

master -up-> heroku
master -up-> source

note right of master
on local machine
end note

note right of source
on github
end note
{% enduml %}

```bash Create the local 'master' git repository
rake tmp:clear
git init .
git add -f *
git commit -a -m"Initial commit"
```

I regularly run those `git` commands to make it easier to revert any mistakes I happen to make.

### Adding ember framework

I have tried two alternative approaches to creating a new rails app for ember. 

#### Alternative 1: use the ember 'edge template'

I think this one is probably the best as it was demonstrated by Yehuda Katz (main Ember guy) in [this live demonstration video](http://www.youtube.com/watch?v=BpQj9_qEUAc). I ran a diff on projects created with and without and it seems to:

- adds some ember gems to the Gemfile: `active_model_serializers`, `ember-rails` and `ember-source`
- remove the rails 'application view layout' (_app/views/layouts/application.html.erb_)
- create an ember 'application template' (_app/assets/javascripts/templates/application.handlebars_)
- creates a 'view asset' that generates an index.html with the ember application.js in it (_app/views/assets/index.html.erb_)
- sets up a rails route pointing to the assets controller 'index' action (_config/routes.rb_)
- create empty assets controller and helper files (not sure why)
- create a rails ActiveModel 'application serializer' (_app/serializers/application_serializer.rb_) that does a few things ember requires <!-- x_ -->

Installing using the edge template is simple. Just replace the `rails new` step above with the following:

```bash Creating a rails app using the ember template
rails new myapp --database=postgresql -m http://emberjs.com/edge_template.rb
cd myapp

# edit your database config and Gemfile as before...
```

_Note: I had problems using the remote edge template, so downloaded it and used my local copy instad._

#### Alternative 2: add ember to an existing rails app

You could also just add the `ember-rails` gem directly to your Gemfile, then run `rails generate ember:bootstrap` and you get a basic Ember framework in your `app/assets` directory. I also prefer to use javascript directly (as opposed to CoffeeScript, which is the default), so add `-g --javascript-engine js`

```bash Add a simple Ember application framework to the Rails app
vim Gemfile
# add 'gem "ember-rails", github: "emberjs/ember-rails"'
```

Following this approach I believe you'll have to manually set up the [Ember ActiveModel Serializer](https://github.com/rails-api/active_model_serializers) which was written by the Ember guys, and ensures your Ember app understands the format of your Rails app's JSON data. The first alternative does this for you.

#### Common to both approaches

After you have created and updated your Gemfile, you still need to bootstrap the ember environment, and then ensure Ember is running in 'development' mode when Rails is.

_Note: you can Set 'developer mode' (which enables developer-centric error messages and is apparently quite useful) by updating your _config/environments/development.rb_ with: `config.ember.variant = :development`. By default running locally will run in dev mode, and running on Heroku will run production mode however._

```bash Add a simple Ember application framework to the Rails app
bundle install
bundle exec rails g ember:bootstrap -g --javascript-engine js
bundle exec rails g ember:install --head

vim config/environments/development.rb # add config.ember.variant = :development
```

## Deploying to Heroku

Heroku requires a few rails settings to be modified to work properly:

```bash Change rails app settings for Heroku
vim config/environments/production.rb # heroku runs in prod mode by default
# change 'config.serve_static_assets' to true

vim Gemfile
# add "gem 'rails_12factor'"
```

I have already gone through the Heroku sign up process and installed the toolbelt appropriate for OSX (the toolbelt provides the `heroku` command line tool), so I won't outline that here.

Installing my rails application on Heroku was then a simple matter of:

```bash Add application in the current directory to Heroku
heroku login
heroku create --stack cedar
git push heroku master

# whenever you make database changes
heroku run rake db:migrate

# if you want to push your local database contents to heroku
heroku db:push # requires the 'taps' gem ('gem install taps')
```

This creates an image with a particular configuration of applications and adds a `heroku` git remote to the git configuration.

Now you can visit the heroku app online (in my case at http://seshbot.herokuapp.com/).

TODO: use `gem rails_12factor`? This alters the rails app a little to make it [12 factor](http://12factor.net/), which is a set of guidelines for how one should build an application to make it easier to administer and deploy. Not really important right now though.

<!-- x_ -->

## Troubleshooting and administering Heroku

```bash Various heroku debugging commands
heroku ps    # list running apps
heroku logs  # show application logs
heroku run console # run interactive ruby console
```

```bash Various heroku administrative commands
heroku config  # configure remote app through environment variables
heroku apps    # overview of apps
heroku destroy # deallocate remote server
heroku run rake db:migrate
```

`heroku config` sets environment variables for things you don't want to commit to git (e.g., passwords). Configure your Rails apps to use `ENV['MY_VAR']` instead of your super secret key, then run `heroku config:add MY_VAR=blahblah`.

There are also various `heroku pg:` commands for updating the application database. The application itself doesn't have full admin access to the database so you can't for example write `heroku run rake db:drop`. Instead you should run `heroku pg:reset` if you want to clear the database.
