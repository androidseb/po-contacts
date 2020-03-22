// Shell command function, based on this SO answer:
//https://stackoverflow.com/a/33650908/3407126
try {
    const execSync = require('child_process').execSync;
    function _jspocExecuteShellCommand(shellCommand) {
        return execSync(shellCommand);
    }
} catch (error) {
    console.error(error, error.stack);
}

//Platform name function to detect what OS is running
{
    try {
        const platformName = require('os').platform().name;
        function _jspocGetPlatformName() {
            return platformName;
        }
    } catch (error) {
        console.error(error, error.stack);
        function _jspocGetPlatformName() {
            return 'linux';
        }
    }
}
