import 'dart:math';

import 'package:po_contacts_flutter/utils/utils.dart';

abstract class TaskSetProgressCallback {
  final List<int> taskIds;
  bool _terminated = false;
  int _currentTask = 0;
  int _lastApproximateProgress = 0;
  double _currentProgress = 0;

  final Function(int taskId, int progress) _progressCallback;

  TaskSetProgressCallback(this.taskIds, this._progressCallback) {
    updateLoop();
  }

  void updateLoop() async {
    if (taskIds.isEmpty) {
      return;
    }
    do {
      final int progress = (_currentProgress * 100).floor();
      final int tasksCount = taskIds.length;
      final int taskIndex = min(tasksCount - 1, _currentTask);
      final int basePercentage = (100 * taskIndex / tasksCount).floor();
      final int relativePercentage = (progress / tasksCount).floor();
      final int overallProgress = basePercentage + relativePercentage;
      _progressCallback(taskIds[taskIndex], overallProgress);
      await Future<Object>.delayed(const Duration(milliseconds: 16));
    } while (!_terminated);
  }

  Future<void> reportOneTaskCompleted() async {
    _currentTask++;
    if (_currentTask < taskIds.length) {
      await broadcastProgress(0);
    }
  }

  Future<void> broadcastProgress(final double progress) async {
    _currentProgress = progress;
    final int approximateProgress = (100 * progress).floor();
    if (approximateProgress == _lastApproximateProgress) {
      return;
    }
    _lastApproximateProgress = approximateProgress;
    await Utils.yieldMainQueue();
  }

  void reportAllTasksFinished(final int error) {
    _terminated = true;
    _progressCallback(taskIds[taskIds.length - 1], error);
  }
}
