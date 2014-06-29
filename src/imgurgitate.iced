#!/usr/bin/env iced
# from http://maxtaco.github.com/coffee-script/

path = require 'path'
fs = require 'fs'
util = require 'util'
underscore = require 'underscore'
request = require 'request'
httpget = require 'http-get'

imgur_album_url_pattern = RegExp("^http://(?:www\.)?imgur\.com/a/([a-zA-Z0-9]+)","i")
imgur_url_pattern = RegExp("^http://((www)|(i)\.)?imgur.com/[./a-zA-Z0-9&,]+","ig")
imgur_hashes_pattern = RegExp("imgur\.com/(([a-zA-Z0-9]{5,}[&,]?)+)","i")
imgur_image_pattern = RegExp("^http://(www\.)?(i\.)?imgur\.com/.{3}\.((jpg)|(gif))","ig")
reddit_user_url_pattern = RegExp("^http://(?:www.)?reddit.com/user/([^/]+)","ig")

rurl = (user,after=null) ->
    "http://reddit.com/user/#{user}.json" + if after then "?after=#{after}" else ""

list_user_images = (user,callback,after=null) ->
    url = rurl(user,after)
    console.log("history",url)
    await request(url, defer(error,response))
    hashes = []
    if (!error && response.statusCode == 200)

        j = JSON.parse(response.body)
        if not j.data
            console.warn(j)
            return
        after = j.data.after
        urls = extract_img_urls(j.data.children)
        #console.log(urls)
        
        for url in urls
            album_match = imgur_album_url_pattern.exec(url)
            if album_match
                id = album_match[1]
                console.log("album",album_match[0])
                await album_to_hashes(id,defer(contents))
                if contents
                    hashes = hashes.concat(contents)
            else
                hashes = hashes.concat(imgur_hashes(url))
        if after
            later = []
            await list_user_images(user,defer(later),after)
            hashes = hashes.concat(later)
        else
            console.log("history","over")
    else if error
        throw error
    else if response.statusCode != 200
        console.warn(response)
    callback(hashes)
   
list_user_albums = (user,callback,after=null) ->
    url = rurl(user,after)
    console.log("history",url)
    await request(url, defer(error,response))
    albums = []
    if (!error && response.statusCode == 200)

        j = JSON.parse(response.body)
        if not j.data
            console.warn(j)
            return
        after = j.data.after
        urls = extract_img_urls(j.data.children)
        #console.log(urls)
        
        for url in urls
            album_match = imgur_album_url_pattern.exec(url)
            if album_match
                id = album_match[1]
                albums = albums.concat([id])
        if after
            later = []
            await list_user_albums(user,defer(later),after)
            albums = albums.concat(later)
        else
            console.log("history","over")
    else if error
        throw error
    else if response.statusCode != 200
        console.warn(response)
    callback(albums)

download_imgur = (hash,folder,callback) ->
    #console.log(url, destination)
    #url1 = "http://imgur.com/#{hash}"   # returns 200 if exists or 500 if not
    # sometimes see http code 304, don't understand when
    url = "http://i.imgur.com/#{hash}.jpg" # returns 200 regardless :/
    await httpget.head({url:url},defer(err,result))
    if (!err and result.code==200)
        if ( result.headers['content-length'] == '503')
            # length of the 'image missing message'
            console.warn("#{url} no longer avaliable")
            callback(err)
            return
        extension = result.headers['content-type'].replace('image/','')
        timestamp = new Date(result.headers['last-modified'])
        url = "http://i.imgur.com/#{hash}.jpg"
        name = folder.split(path.sep).slice(-1)[0]
        destination = path.join("#{folder}","#{name}-#{timestamp.toISOString().replace(/:/g,'.')}-#{hash}.#{extension}")
        await fs.stat(destination,defer(err, stats))

        if (!err && stats.size > parseInt(result.headers['content-length']))
            console.warn(url,'conflicts with',destination)           
        else if (!err && stats.size == parseInt(result.headers['content-length']))
            console.log(url,destination,'previously')
        else    
            console.log(url,destination)
            await httpget.get({url:url},destination,defer(err,result))
            # change modification date of downloaded file
            await fs.utimes(destination,timestamp,timestamp,defer())
    callback(err)
   
    
imgur_hashes = (url) ->
    hashes = []
    match = imgur_hashes_pattern.exec(url)
    if match
       hashes = match[1].split(/[,&]/) 
    return hashes
    
album_to_hashes = (album_id,callback) ->
    # http://api.imgur.com/resources_anon#album
    url = "http://api.imgur.com/2/album/#{album_id}.json"
    await request(url, defer(error,response))
    if (!error && response.statusCode == 200)
        j = JSON.parse(response.body)
        hashes = (x.image.hash for x in j.album.images)
    callback(hashes)
       
extract_img_urls = (children) ->
    urls = []
    for thing in children
        type = null
        d = thing.data
        if (argv.whitelist? && d.subreddit not in argv.whitelist.split(','))
            continue
        created_utc = d.created_utc
        if thing.kind == 't1'
            type = 'comment'
        else if thing.kind == 't3'
            type = 'post'
            match = imgur_url_pattern.exec(d.url)
            if match
                url = match[0]
                urls.push(url)
        if d.body
            text = d.body
            while (match = imgur_url_pattern.exec(text))
                url = match[0]
                urls.push(url)
    return urls
    
    
if (!module.parent)        
    argv = require('optimist').usage(
        ["Download Imgur albums to disk",
        "Usage: $0 url",
        "Where url is either an Imgur album or a Reddit user"].join("\n"))
        .boolean("albums").describe("albums", "In the case url is a Reddit user, ignore loose images and download only their albums.")
        .demand(1).argv
    for arg in argv._
        console.log(arg)
        album_match = imgur_album_url_pattern.exec(arg)
        
        if album_match
            id = album_match[1]
            folder = id
            await album_to_hashes(id,defer(hashes))
        else if imgur_url_pattern.exec(arg)
            hashes = imgur_hashes(arg)
            folder = hashes[0]
        else
            rurl_match = reddit_user_url_pattern.exec(arg)
            if rurl_match
                user = rurl_match[1]
            else
                user = arg

            if (!fs.existsSync(user))
                fs.mkdirSync(user)

            if argv.albums
                await list_user_albums(user,defer(albums))
                for album in underscore.unique(albums)
                    await album_to_hashes(album,defer(hashes))
                    folder = path.join(user, album)
                    if (!fs.existsSync(folder))
                        fs.mkdirSync(folder)
                    for hash in hashes
                        await download_imgur(hash,folder,defer())

                continue

            await list_user_images(user,defer(hashes))
            hashes = underscore.unique(hashes)
            folder = user
            
        if (!fs.existsSync(folder))
            fs.mkdirSync(folder)
        for hash in hashes
            await download_imgur(hash,folder,defer())
