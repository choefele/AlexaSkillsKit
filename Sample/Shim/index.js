'use strict';

const spawnSync = require('child_process').spawnSync;

exports.handler = (event, context, callback) => {
    // Invoke the executable via the provided ld-linux.so – this will
    // force the right GLIBC version and its dependencies
    const options = { input:JSON.stringify(event) };
    const command = 'libraries/ld-linux-x86-64.so.2';
    const childObject = spawnSync(command, ["--library-path", "libraries", "./Lambda"], options)

    if (childObject.error) {
        callback(error, null);
    } else {
        try {
            // The executable's raw stdout is the Lambda output
            var stdout = childObject.stdout.toString('utf8');
            var stderr = childObject.stderr.toString('utf8');
            var response = JSON.parse(stdout);
            callback(null, response);
        } catch(e) {
            e.message += ": \"" + stdout + "\""
            callback(e, null);
        }
    }
};
