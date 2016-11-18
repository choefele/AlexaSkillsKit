'use strict';

process.env['PATH'] = process.env['PATH'] + ':' + process.env['LAMBDA_TASK_ROOT']

const spawnSync = require('child_process').spawnSync;

/**  
     Defines a handler function called "index.handler" to Lambda.

     This function takes an `event` object as input, and invokes the
     `swiftcommand` executable.
     
     If the executable completes without error, the handler
     callback-returns an object of the form

     { 
     input: event
     output: stdout
     }

     If the executable errors, the handler returns an error (?).

     In all cases, the executable's stdout is logged to the console as
     a log message, and its stderr is logged as error messages.
     
*/
exports.handler = (event, context, callback) => {
    const options = {
        input:JSON.stringify(event)
    };

    var command = '';
    if (event.command) {
        command = event.command;
    } else {
        command = 'libraries/ld-linux-x86-64.so.2';
    }
  
    const childObject = spawnSync(command, ["--library-path", "libraries", "./Lambda"], options)

    var error = childObject.error;
    var stdout = childObject.stdout.toString('utf8');
    var stderr = childObject.stderr.toString('utf8');

    if (error) {
        callback(error, null);
    } else {
        try {
            // Executable's raw stdout is the Lambda output
            var response = JSON.parse(stdout);
            callback(null, response);
        } catch(e) {
            e.message += ": \"" + stdout + "\""
            callback(e, null);
        }
    }
};
