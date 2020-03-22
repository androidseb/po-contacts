@JS()
library pocjsapi;

import 'package:js/js.dart';

external String _jspocExecuteShellCommand(final String shellCommand);
external String _jspocGetPlatformName();

class POCJSAPI {
  static String executeShellCommand(final String shellCommand) {
    return _jspocExecuteShellCommand(shellCommand);
  }

  static String getPlatformName() {
    return _jspocGetPlatformName();
  }
}
