path = require 'path'
fs = require 'fs'
spawn = (require 'child_process').spawn
wrench = require 'wrench'

# Run a CoffeeScript through our node/coffee interpreter.
run = (args, cb) ->
  proc = spawn 'node', ['./node_modules/iced-coffee-script/bin/coffee'].concat(args)
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on        'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

task 'build', 'Compile IcedCoffeeScript source to Javascript', ->
    invoke 'clean'
    await run ['-o','lib','-c','src'], defer()
    
    # prepend shebang manually until issue fixed
    # https://github.com/jashkenas/coffee-script/issues/2215
    script_path = path.join('lib','imgurgitate.js')
    shebang = "#!/usr/bin/env node"  
    fs.writeFileSync(script_path,[shebang,fs.readFileSync(script_path)].join("\n"))
        
task 'clean', 'Clean build matter', ->
    wrench.rmdirSyncRecursive('lib',true)
    wrench.rmdirSyncRecursive('-p',true)
    