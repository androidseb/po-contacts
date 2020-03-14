// Shell command function, based on this SO answer:
//https://stackoverflow.com/a/33650908/3407126
{
    const execSync = require('child_process').execSync;
    function jspocExecuteShellCommand(shellCommand) {
        return execSync(shellCommand);
    }
}
