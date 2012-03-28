path = require 'path'
fs = require 'fs'

task 'build', 'Compile Coffeescript source to Javascript', ->
    command = require 'iced-coffee-script/lib/coffee-script/command'
    process.argv[2..]=['-o','lib','-c','src']
    command.run()   # this returns early and doesn't indicate error
      
    # wait a little
    await setTimeout(defer(),1000)
    
    # prepend shebang until issue fixed
    # https://github.com/jashkenas/coffee-script/issues/2215
       
    script_path = path.join('lib','imgurgitate.js')
    shebang = "#!/usr/bin/env node"  
    fs.writeFileSync(script_path,[shebang,fs.readFileSync(script_path)].join("\n"))
    
    
    
task 'clean', 'Clean build matter', ->
    wrench = require 'wrench'
    wrench.rmdirSyncRecursive('lib',true)
    wrench.rmdirSyncRecursive('-p',true)
    