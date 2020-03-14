@JS()
library pocjsapi;

import 'package:js/js.dart';

external String jspocExecuteShellCommand(final String shellCommand);

class POCJSAPI {
  static String executeShellCommand(final String shellCommand) {
    return jspocExecuteShellCommand(shellCommand);
  }
}
