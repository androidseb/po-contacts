/// Utility class to allow explicitly yielding access back to the UI thread.
/// This can be useful when performing heavy operations and not using isolates.
/// The yielding is done with a call to
/// Future.delayed(const Duration(milliseconds: 0));
/// Since systematically yielding access back to the UI thread would cause a high lag on the operations by
/// waiting on the event queue a lot, the rate at which we actually yield back to the UI thread is dynamically
/// adjusted depending on the current event queue framerate (higher than 60 FPS).
class MainQueueYielder {
  // The minimum framerate we want to maintain. When we're below this value, we want
  // to increase the rate at which we yield to the main queue to increase framerate.
  static const double _MINIMUM_TARGET_FRAMERATE = 60.0;
  // The minimum "comfortable" framerate. When we're above this value, we can start
  // decreasing the rate at which we yield to the main queue, speeding up operations.
  static const double _MINIMUM_INCREMENT_FRAMERATE = 70.0;
  // The factor by which we "tweak" the rate at which we're yielding to the main queue
  static const double _ITERATIONS_TWEAK_FACTOR = 1.1;
  // The minimum iterations count before yielding to the main queue
  static const double MIN_ITERATIONS_COUNT = 10;
  // The framerate probe to get an estimation of the current framerate
  static final _FrameRateProbe _frameRateProbe = _FrameRateProbe();
  // The current count of iterations where we have not yielded to the main queue
  static int _currentIterationsCount = 0;
  // The target number of iterations where we will not yield to the main queue
  static double _targetIterationsCount = MIN_ITERATIONS_COUNT;

  static Future<void> check() async {
    if (_currentIterationsCount < _targetIterationsCount) {
      _currentIterationsCount++;
      return;
    }
    _currentIterationsCount = 0;
    final double frameRateEstimate = _frameRateProbe.consumeFrameRateEstimate;
    if (frameRateEstimate != null) {
      if (frameRateEstimate < _MINIMUM_TARGET_FRAMERATE) {
        if (_targetIterationsCount > MIN_ITERATIONS_COUNT) {
          _targetIterationsCount = _targetIterationsCount / _ITERATIONS_TWEAK_FACTOR;
        }
      } else if (frameRateEstimate > _MINIMUM_INCREMENT_FRAMERATE) {
        _targetIterationsCount = _targetIterationsCount * _ITERATIONS_TWEAK_FACTOR;
      }
    }
    return Future.delayed(const Duration(milliseconds: 0));
  }
}

class _FrameRateProbe {
  static const int _ONE_SECOND_IN_MICROSECONDS = 1000000;
  static const double _TARGET_FRAMERATE = 120;
  static const int _FRAME_INTERVAL_MICROSECONDS = _ONE_SECOND_IN_MICROSECONDS ~/ _TARGET_FRAMERATE;
  static double _frameRateEstimate = _TARGET_FRAMERATE;

  static int currentTimeMicroSeconds() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  _FrameRateProbe() {
    _measureFrameRate();
  }

  double get consumeFrameRateEstimate {
    final double res = _frameRateEstimate;
    _frameRateEstimate = null;
    return res;
  }

  void _measureFrameRate() async {
    while (true) {
      final int startTime = currentTimeMicroSeconds();
      await Future<void>.delayed(const Duration(microseconds: _FRAME_INTERVAL_MICROSECONDS));
      final int endTime = currentTimeMicroSeconds();
      final int elapsedTime = endTime - startTime;
      _frameRateEstimate = _ONE_SECOND_IN_MICROSECONDS / elapsedTime;
    }
  }
}
