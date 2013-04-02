Imgurgitate
=========

Download [Imgur](http://imgur.com) albums to disk. Download all of a [Redditor's](http://www.reddit.com/) albums to disk.

Usage
----

    Download Imgur albums to disk
    Usage: imgurgitate album_url
    Usage imgurgitate reddit_user

Installation
----------

First install [Node.js](http://nodejs.org/). Then install imgurgitate using the wonderful package manager `npm` distributed with Node.

    npm -g install imgurgitate

The executable script `imgurgitate` will be installed in your path alongside `node` and `npm`, or on Windows to `%appdata%\npm`. See npm's [folders(1)](http://npmjs.org/doc/folders.html)
   
Example usage
-----

Download an album:

    imgurgitate http://imgur.com/a/SS6V5
   
Download a user's uploads:

    imgurgitate http://www.reddit.com/user/Shitty_Watercolour
   
Development
----

[![Build Status](https://travis-ci.org/matt-hickford/imgurgitate.png?branch=master)](https://travis-ci.org/matt-hickford/imgurgitate)

You only need to read these instructions if you would like to develop the software. First, install [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/) `npm install -g iced-coffee-script`, then

    git clone https://github.com/matt-hickford/imgurgitate.git
    
    icake build
    node lib/imgurgitate.js
    icake clean

To publish to [npm registry](https://new.npmjs.org/package/imgurgitate)
    
    npm publish
