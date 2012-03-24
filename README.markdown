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

The script `imgurgitate` will be installed in your path or if you omit the `-g` flag to `~/node_modules/.bin` or `%appdata%\npm` (Windows).
   
Build and release
----

(These instructions are useful only to me)

    iced -o lib -c src/imgurgitate.iced
    npm publish

Prepend a shebang line `#!/usr/bin/env node` to the js file `lib/imgurgitate.js`
