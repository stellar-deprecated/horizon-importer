# Developing

This project is a Ruby on Rails project, using jruby.

## Prerequisites

- JDK 7 or greater
- rbenv - (https://github.com/sstephenson/rbenv) (optional, but recommended)
- ruby-build - (https://github.com/sstephenson/ruby-build) (optional, but recommended)
- rbenv-vars - (https://github.com/sstephenson/rbenv-vars) (optional, but recommended)
- jruby 1.7.19 (recommended you install using rbenv)
- ruby 1.9.3 (optional, but recommended)
- bundler - (http://bundler.io/)
- libsodium
- postgresql

## Development Workflow Speed

jruby can be a bit slow when it comes to startup.  While this doesn't affect your running service (one jruby gets warmed up it is usually faster than MRI) it does affect things like running `rails g` or `rake routes` or running your specs with guard.

While there are several solutions to speed up startup time, here's what this project currently does:  *(NOTE: we're definitely open to contributions to improve our startup time)*

First, we use rbenv-vars to make sure jruby is run with the --dev flag.  That gives a good percentage improvement, but the our most impactful strategy to affect development workflow speed is to use MRI for development. `./bin/fast` will execute any command provided to it using a native ruby, via rbenv.  For example `./bin/fast rails g controller coins` will run the generator using ruby 1.9.3 (provided it is installed via rbenv). Guard is configured to use `./bin/fast` for running specs, meaning you get a nice, snappy feedback loop while developing.

## Installing Prerequisites on OS X

### Installing Homebrew

The following instructions assume that you are using [homebrew](http://brew.sh/), a package manager for OS X.  To install homebrew, please visit http://brew.sh/ and follow the instructions.

### Installing the JDK

Download the Oracle Java 8 JDK from [here](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and run the installer

#### Activating the JDK

After installation, you'll need to tell your shell to use the latest jdk (as opposed to the jdk installed by apple).  Put the following in your shell's initialization file (your `.bashrc` or equivalent):

```bash
export JAVA_HOME=$(/usr/libexec/java_home)
```

Running `java -version` should now give you something like:

```bash
 java -version
java version "1.8.0_31"
Java(TM) SE Runtime Environment (build 1.8.0_31-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.31-b07, mixed mode)
```

### Installing rbenv, ruby-build, and rbenv-vars

While optional, it's highly recommended you use some sort of ruby version manager to install jruby and ruby. My personal preference is [rbenv](https://github.com/sstephenson/rbenv), but [rvm](https://rvm.io) will work as well.

```bash
brew install rbenv
brew install ruby-build
brew install rbenv-vars
```

Some additional instructions for how to activate each of these will be printed by homebrew after each step, if necessary.  please follow them to activate rbenv for your shell

###  Installing jruby and MRI 1.9.3

Now that we have rbenv and ruby-build installed, we can use them to get our 2 ruby interpeters installed:

```bash
rbenv install jruby-1.7.19
rbenv install 1.9.3-p547
```

You can confirm they were installed successfully using:

```bash
➜ RBENV_VERSION=1.9.3-p547 ruby -v
ruby 1.9.3p547 (2014-05-14 revision 45962) [x86_64-darwin13.4.0]
➜ RBENV_VERSION=jruby-1.7.19 ruby -v
jruby 1.7.19 (1.9.3p551) 2015-01-29 20786bd on Java HotSpot(TM) 64-Bit Server VM 1.8.0_31-b13 +jit [darwin-x86_64]
```

### Installing bundler

```bash
RBENV_VERSION=jruby-1.7.19 gem install bundler
RBENV_VERSION=1.9.3-p547 gem install bundler
```

### Installing libsodium

```bash
brew install libsodium
```

### Installing postgresql

There are several ways to install postgres, please [see the downloads page for more details](http://www.postgresql.org/download/macosx/).  Let's assume homebrew:

```bash
brew install postgresql
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

## Setting up Horizon

Whew! That's was quite a process.  Now let's go about setting up horizon and running our test suite.  This process will involve:

- Creating postgres databases
- Installing rubygem dependencies
- Running migrations to populate database schema
- Running the test suite

### Creating databases
### Installing rubygem dependencies
### Running migrations to populate database schema
### Running the test suite

