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
        const platformName = require('os').platform();
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

//Overriding the window.open function so that it opens the system browser instead of a nwjs window
{
    try {
        const gui = require('nw.gui');
        function _windowOpenOverride(url) {
            gui.Shell.openExternal(url);
        }
        window.open = _windowOpenOverride;
    } catch (error) {
        console.error(error, error.stack);
    }
}

//Overriding the window.localStorage functions to read/write to files if the key starts with abstractfs://
{
    try {
        const fs = require('fs');
        const fsPrefix = 'abstractfs://';
        const userFilesDir = nw.App.dataPath + '/user_files';
        const _abstractFSPathToRealPath = (abstractFilePath) => {
            if (abstractFilePath == null) {
                return null;
            }
            return userFilesDir + '/' + abstractFilePath.substring(fsPrefix.length).split('/').join('-');
        };
        const realGetItem = window.localStorage.getItem.bind(window.localStorage);
        const realSetItem = window.localStorage.setItem.bind(window.localStorage);
        const realRemoveItem = window.localStorage.removeItem.bind(window.localStorage);
        window.localStorage.getItem = (itemKey) => {
            if (itemKey == null || !itemKey.startsWith(fsPrefix)) {
                return realGetItem(itemKey);
            }
            var filePath = _abstractFSPathToRealPath(itemKey);
            try {
                return fs.readFileSync(filePath, { encoding: 'utf-8' });
            } catch (_) {
                return null;
            }
        };
        window.localStorage.setItem = (itemKey, itemValue) => {
            if (itemKey == null || !itemKey.startsWith(fsPrefix)) {
                return realSetItem(itemKey, itemValue);
            }
            realSetItem(itemKey, 'file');
            var filePath = _abstractFSPathToRealPath(itemKey);
            fs.writeFileSync(filePath, itemValue, { encoding: 'utf-8' });
        };
        window.localStorage.removeItem = (itemKey) => {
            if (itemKey == null || !itemKey.startsWith(fsPrefix)) {
                return realRemoveItem(itemKey);
            }
            realRemoveItem(itemKey);
            var filePath = _abstractFSPathToRealPath(itemKey);
            try {
                fs.unlinkSync(filePath);
            } catch (_) {
            }
        };
        try {
            fs.mkdirSync(userFilesDir, {});
        } catch (error) {
            // User dir is already created
        }
    } catch (error) {
        console.error(error, error.stack);
    }
}
