import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/sync_controller.dart';

class SyncButton extends StatefulWidget {
  @override
  _SyncButtonState createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> with TickerProviderStateMixin {
  AnimationController _animationController;
  SyncState _syncState = SyncState.IDLE;
  StreamSubscription<SyncState> _syncStateStreamSubscription;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _syncStateStreamSubscription =
        MainController.get().syncController.syncStateStream.listen((event) {
      _updateSyncState(MainController.get().syncController.syncState);
    });
    super.initState();
  }

  void _updateSyncState(final SyncState syncState) {
    setState(() {
      _syncState = syncState;
    });
    if (_syncState == SyncState.SYNCING) {
      _animationController.repeat();
    } else {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _syncStateStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 1.0, end: 0.0).animate(_animationController),
      child: IconButton(
        icon: Icon(_syncState == SyncState.LAST_SYNC_FAILED
            ? Icons.sync_problem
            : Icons.sync),
        onPressed: _syncState == SyncState.SYNCING
            ? null
            : () {
                if (_syncState == SyncState.SYNCING) {
                  return;
                }
                MainController.get().syncController.onClickSyncButton();
              },
      ),
    );
  }
}
