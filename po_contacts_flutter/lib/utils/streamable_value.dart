import 'dart:async';

import 'package:flutter/widgets.dart';

class StreamableValue<T> {
  T _currentValue;
  final StreamController<T> _valueStreamController = StreamController();
  ReadOnlyStreamableValue<T> _readOnly;
  Stream<T> _valueStream;

  StreamableValue(final T initialValue) {
    _currentValue = initialValue;
    _readOnly = ReadOnlyStreamableValue(this);
  }

  Stream<T> get valueStream {
    if (_valueStream == null) {
      _valueStream = _valueStreamController.stream.asBroadcastStream();
    }
    return _valueStream;
  }

  T get currentValue => _currentValue;

  set currentValue(final T newCurrentValue) {
    _currentValue = newCurrentValue;
    _valueStreamController.add(_currentValue);
  }

  ReadOnlyStreamableValue<T> get readOnly => _readOnly;
}

class ReadOnlyStreamableValue<T> {
  StreamableValue<T> _parentValue;
  ReadOnlyStreamableValue(final StreamableValue<T> parentValue) {
    _parentValue = parentValue;
  }

  Stream<T> get valueStream => _parentValue.valueStream;
  T get currentValue => _parentValue.currentValue;
}

class StreamedWidget<T> extends StatefulWidget {
  final ReadOnlyStreamableValue<T> streamableValue;
  final Widget Function(BuildContext context, T value) widgetBuilder;
  StreamedWidget(this.streamableValue, this.widgetBuilder);
  @override
  _StreamedWidgetState<T> createState() => _StreamedWidgetState<T>();
}

class _StreamedWidgetState<T> extends State<StreamedWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.streamableValue.valueStream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        final T currentValue = snapshot.data == null
            ? widget.streamableValue.currentValue
            : snapshot.data;
        return widget.widgetBuilder(context, currentValue);
      },
    );
  }
}
