#!/usr/bin/env iced
# http://maxtaco.github.com/coffee-script/
request = require('request')
prettyjson = require('prettyjson')
htmlparser2 = require('htmlparser2')
underscore = require('underscore')
httpget = require('http-get')
path = require('path')
fs = require('fs')
util = require('util')

imgur_url_pattern = RegExp("http://((www)|(i)\.)?imgur.com/[./a-zA-Z0-9&,]+","ig")

imgur_album_url_pattern = RegExp("imgur\.com/a/([a-zA-Z0-9]+)","i")
imgur_hashes_pattern = RegExp("imgur\.com/(([a-zA-Z0-9]{5}[&,]?)+)","i")

imgur_image_pattern = RegExp("http://(www\.)?(i\.)?imgur\.com/.{3,7}\.((jpg)|(gif))","ig")

rurl = (user,after=null) ->
    "http://reddit.com/user/#{user}.json" + if after then "?after=#{after}" else ""

list_user_images = (user,callback,after=null) ->
    url = rurl(user,after)
    console.log(url)
    await request(url, defer(error,response))
    hashes = []
    if (!error && response.statusCode == 200)

        j = JSON.parse(response.body)
        if not j.data
            console.warn(j)
            return
        after = j.data.after
        #console.log(prettyjson.render(j.data))
        urls = extract_img_urls(j.data.children)
        #console.log(urls)
        
        for url in urls
            if imgur_album_url_pattern.exec(url)
                #console.log('album',url)
                await browse_album(url,defer(contents))
                hashes = hashes.concat(contents)
            else
                hashes = hashes.concat(imgur_hashes(url))
        #console.log(hashes)
        if after
            later = []
            await list_user_images(user,defer(later),after)
            hashes = hashes.concat(later)
    else if error
        throw error
    else if response.statusCode != 200
        console.warn(response)
    callback(hashes)
   
download_imgur = (hash,user,callback) ->
    #console.log(url, destination)
    #url1 = "http://imgur.com/#{hash}"   # returns 200 if exists or 500 if not
    url = "http://i.imgur.com/#{hash}.jpg" # returns 200 regardless :\
    await httpget.head({url:url},defer(err,result))
    if (!err and result.code==200 and result.headers['content-length']!=669)    # 669 is length of the 'image missing message'
        extension = result.headers['content-type'].replace('image/','')
        timestamp = new Date(result.headers['last-modified'])
        url = "http://i.imgur.com/#{hash}.jpg"
        destination = path.join("#{user}","#{user}-#{timestamp.toISOString().replace(/:/g,'.')}-#{hash}.#{extension}")
        await fs.stat(destination,defer(err, stats))
        if (!err and stats.size == parseInt(result.headers['content-length']))
            console.log(url,destination,'previously')
        else    
            console.log(url,destination)
            await httpget.get({url:url},destination,defer(err,result))
            await fs.utimes(destination,timestamp,timestamp,defer())
        # change modification date of downloaded file
    callback(err)
   
    
imgur_hashes = (url) ->
    hashes = []
    match = imgur_hashes_pattern.exec(url)
    if match
       hashes = match[1].split(/[,&]/) 
    return hashes

browse_album = (url,callback) ->
    # callback we have an async method inside
    hashes = []
    await request(url, defer(error,response))
    if (!error && response.statusCode == 200)
        handler = new htmlparser2.DefaultHandler()
        parser = new htmlparser2.Parser(handler)
        parser.parseComplete(response.body)
        #console.log('browsing')
        for element in htmlparser2.DomUtils.getElements({class:"image"},handler.dom)
            hash = element.attribs['id']
            hashes.push(hash)
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
        ["Download Imgur albums to disk","Usage: $0 album_url","Usage: $0 reddit_user"].join("\n")
        ).demand(1).argv
    for arg in argv._
        console.log(arg)
        album_match = imgur_album_url_pattern.exec(arg)
        if album_match
            url = arg
            folder = album_match[1]
            await browse_album(url,defer(hashes))
        else
            user = arg
            await list_user_images(user,defer(hashes))
            hashes = underscore.unique(hashes)
            folder = user
        if (!path.existsSync(folder))
            fs.mkdirSync(folder)
        for hash in hashes
            await download_imgur(hash,folder,defer())
