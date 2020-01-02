class I18nString {
  final String app_name = 'app_name';
}

class I18n {
  static final I18nString string = new I18nString();

  static Map<String, String> currentTranslation = {
    string.app_name: 'PO Contacts',
  };

  static _getObjString(final Object _obj) {
    if (_obj == null) {
      return '';
    }
    return _obj.toString();
  }

  static _getStringWithReplacement(
      final String _sourceStr, final int _strIndex, final int _replacedLength, final Object _replacementObj) {
    return _sourceStr.substring(0, _strIndex) +
        _getObjString(_replacementObj) +
        _sourceStr.substring(_strIndex + _replacedLength, _sourceStr.length);
  }

  static getString(final String _stringKey, [final Object _param1, final Object _param2, final Object _param3]) {
    String resString = I18n.currentTranslation[_stringKey];
    if (resString == null) {
      return _stringKey;
    }
    int foundIndex = resString.indexOf('%s');
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 2, _param1);
    }
    foundIndex = resString.indexOf('%1\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%1\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param1);
    }
    foundIndex = resString.indexOf('%2\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%2\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param2);
    }
    foundIndex = resString.indexOf('%3\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%3\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param3);
    }
    return resString;
  }
}
