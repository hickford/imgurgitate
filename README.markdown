Imgurgitate
=========

Download [Imgur](http://imgur.com) albums to disk. Download a [Redditor's](http://www.reddit.com/) albums to disk.

Usage
----

    Download Imgur albums to disk
    Usage: imgurgitate album_url
    Usage: imgurgitate reddit_user

Prerequisites
----------

* [Node.js](http://nodejs.org/)

Installation
----------

Install imgurgitate using the wonderful package manager `npm` distributed with Node.

    npm -g install imgurgitate

The executable script `imgurgitate` will be installed in your path alongside `node` and `npm`, or on Windows to `%appdata%\npm`. If you omit the `-g` switch, to `~/node_modules/.bin`. See the npm's [folders(1)](http://npmjs.org/doc/folders.html)
   
Example usage
-----

Download an album:

    imgurgitate http://imgur.com/a/SS6V5
   
   
Development
----

[![Build Status](https://travis-ci.org/matt-hickford/imgurgitate.png?branch=master)](https://travis-ci.org/matt-hickford/imgurgitate)

Clone this project:

    git clone https://github.com/matt-hickford/imgurgitate.git
    cd imgurgitate

Install development dependencies (principally [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/))

    npm install --dev

Build the Coffeescripts to Javascript

    icake build

Publish to [npm registry](https://new.npmjs.org/package/imgurgitate)
    
    npm publish
