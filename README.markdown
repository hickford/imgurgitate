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
   
Build and publish
----

These instructions are really only useful to me. First, install [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/), then

    icake build
    ./lib/imgurgitate.js
    icake clean
    npm publish
