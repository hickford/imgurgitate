cp = require 'child_process'

task 'build', 'Compile Coffeescript source to Javascript', ->
    cp.exec 'iced -o lib -c src', (error, stdout, stderr) ->
        console.error(stderr)
        console.log(stdout)
        if error != null
            console.error(error)
            process.exit(error.code)

