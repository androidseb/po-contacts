//ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html';

class SelectedFileWeb {
  final String fileName;
  final String fileBase64ContentString;
  SelectedFileWeb(
    this.fileName,
    this.fileBase64ContentString,
  );
}

class UtilsWeb {
  static Future<SelectedFileWeb> selectFile(final String mimeType) async {
    final Completer<String> fileNameCompleter = Completer<String>();
    final Completer<String> fileContentCompleter = Completer<String>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = mimeType;
    input.onChange.listen((e) async {
      final File file = input.files[0];
      final FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onError.listen((error) => fileContentCompleter.completeError(error));
      await reader.onLoad.first;
      fileNameCompleter.complete(file.name);
      final String dataUrl = reader.result as String;
      fileContentCompleter.complete(dataUrl);
    });
    input.click();
    final String selectedFileName = await fileNameCompleter.future;
    final String selectedFileBase64DataUrl = await fileContentCompleter.future;
    final String base64StringPrefix = 'base64,';
    int startIndex = 0;
    final int base64PrefixIndex = selectedFileBase64DataUrl.indexOf(base64StringPrefix);
    if (base64PrefixIndex > 0) {
      startIndex = base64PrefixIndex + base64StringPrefix.length;
    }
    final String selectedFileBase64String = selectedFileBase64DataUrl.substring(startIndex);
    return SelectedFileWeb(selectedFileName, selectedFileBase64String);
  }

  static void copyTextToClipBoard(final String text) {
    //Code copied from:
    //https://gist.github.com/bergwerf/1b427ad2b1f9770b260dd4dac295b6f0
    final TextAreaElement tea = TextAreaElement();
    document.body.append(tea);
    tea.style.border = '0';
    tea.style.margin = '0';
    tea.style.padding = '0';
    tea.style.opacity = '0';
    tea.style.position = 'absolute';
    tea.readOnly = true;
    tea.value = text;
    tea.select();
    document.execCommand('copy');
    tea.remove();
  }
}
