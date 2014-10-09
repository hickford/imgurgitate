Imgurgitate
=========

Download [Imgur](http://imgur.com) albums. Download all a  [Redditor's](http://www.reddit.com/) albums.

Usage
----

    Download Imgur albums to disk
    Usage: imgurgitate album_url
    Usage: imgurgitate reddit_user

Installation
----------

[![NPM version](https://badge.fury.io/js/imgurgitate.svg)](https://npmjs.org/package/imgurgitate)

First install [Node.js](http://nodejs.org/). Then install imgurgitate using the wonderful package manager `npm` distributed with Node.

    npm -g install imgurgitate

The executable script `imgurgitate` will be installed in your path alongside `node` and `npm`, or on Windows to `%appdata%\npm`. See npm's [folders(1)](http://npmjs.org/doc/folders.html)
   
Example usage
-----

Download an album:

    imgurgitate http://imgur.com/a/SS6V5
   
Download all a Redditor's albums:

    imgurgitate http://www.reddit.com/user/Shitty_Watercolour
   
Development
----

[![Build Status](https://travis-ci.org/hickford/imgurgitate.png?branch=master)](https://travis-ci.org/hickford/imgurgitate)

Clone this project:

    git clone https://github.com/colonelpanic/imgurgitate.git
    cd imgurgitate

Install development dependencies (principally [Iced CoffeeScript](http://maxtaco.github.com/coffee-script/))

    npm install --dev

Build the Coffeescripts to Javascript

    icake build

Publish to [npm registry](https://npmjs.org/package/imgurgitate)
    
    npm publish
