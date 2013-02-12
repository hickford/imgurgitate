path = require 'path'
fs = require 'fs'
wrench = require 'wrench'

task 'build', 'Compile IcedCoffeeScript source to Javascript', ->
    invoke 'clean'
    command = require 'iced-coffee-script/lib/coffee-script/command'
    process.argv[2..]=['-o','lib','-c','src']
    command.run()   # alas, this returns early and doesn't indicate error
      
    # prepend shebang until issue fixed
    # https://github.com/jashkenas/coffee-script/issues/2215
    
    script_path = path.join('lib','imgurgitate.js')
    shebang = "#!/usr/bin/env node"  

    # wait until script built
    while ! fs.existsSync(script_path)
        await setTimeout(defer(),1000) 
        
    fs.writeFileSync(script_path,[shebang,fs.readFileSync(script_path)].join("\n"))
        
    
task 'clean', 'Clean build matter', ->
    wrench.rmdirSyncRecursive('lib',true)
    wrench.rmdirSyncRecursive('-p',true)
    