Imgurgitate
=========

Download [Imgur](http://imgur.com) albums to disk. Download all of a [Redditor's](http://www.reddit.com/) albums to disk.

Usage
----

    Download Imgur albums to disk
    Usage: imgurgitate album_url
    Usage imgurgitate reddit_user

Prerequisites
----------

* [Node.js](http://nodejs.org/)

Installation
----------

Install imgurgitate using the wonderful package manager `npm` distributed with Node.

    npm -g install imgurgitate

The executable script `imgurgitate` will be installed in your path alongside `node` and `npm`, or on Windows to `%appdata%\npm`. If you omit the `-g` switch, to `~/node_modules/.bin`. See the npm's [folders(1)](http://npmjs.org/doc/folders.html)
   
Tests
-----

Download an album:

    imgurgitate http://imgur.com/a/SS6V5
   

   
Build and publish
----

You only need to read these instructions if you would like to develop the software. First, install [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/) `npm install -g iced-coffee-script`, then

    icake build
    node lib/imgurgitate.js
    icake clean

To publish to [npm registry](https://new.npmjs.org/package/imgurgitate)
    
    npm publish
