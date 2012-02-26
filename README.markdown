Imgurgitate
=========

Script to download all of a Redditor's image uploads to [imgur](http://imgur.com).

Prerequisites
----------

* [Node.js](http://nodejs.org/)

Installation
----------

Install imgurgitate using the wonderful package manager `npm`

    npm -g install imgurgitate

The script `imgurgitate` will be installed in your path or if you omit the `-g` flag to `~/node_modules/.bin` or `%appdata%\npm` (Windows).

Usage
----

    Download a Redditor's imgur uploads to disk
    Usage: imgurgitate user

Build
----

    iced -o lib -c src/imgurgitate.iced

Prepend a shebang line `#!/usr/bin/env node` to the js file `lib/imgurgitate.js`
