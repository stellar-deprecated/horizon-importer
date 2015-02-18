# Stellard API

This rails app is the "sidekick" api server for the stellard core (hayashi).  This
project is intended to be the main interface for software that wishes to 
integrate with the stellar network.  

## Goals

- Robust transaction submission
- Rich transaction history

## Status

early planning/hacking.  

## Requirements For Installation

- Java 7 
- libsodium


## Developing

This project is a Ruby on Rails project, using jruby.

### Prerequisites

- JDK 7 or greater
- rbenv - (https://github.com/sstephenson/rbenv) (optional, but recommended)
- rbenv-vars - (https://github.com/sstephenson/rbenv-vars) (optional, but recommended)
- jruby 1.7.18 (recommended you install using rbenv)
- ruby 2.1.3 (optional, but recommended)
- bundler - (http://bundler.io/)
- libsodium

### Development Workflow Speed

jruby can be a bit slow when it comes to startup.  While this doesn't affect your running service (one jruby gets warmed up it is usually faster than MRI) it does affect things like running `rails g` or `rake routes` or running your specs with guard.

While there are sevral solutions to speed up startup time, here's what this project currently does:  *(NOTE: we're definitely open to contributions to improve our startup time)*

First, we use rbenv-vars to make sure jruby is run with the --dev flag.  That gives a good percentage improvement, but the our most impactful strategy to affect development workflow speed is to use MRI for development. `./bin/fast` will execute any command provided to it using a native ruby, via rbenv.  For example `./bin/fast rails g controller coins` will run the generator using ruby 2.1.3 (provided it is installed via rbenv). Guard is configured to use `./bin/fast` for running specs, meaning you get a nice, snappy feedback loop while developing.

TODO: add instructions for how to install all of the prereqs