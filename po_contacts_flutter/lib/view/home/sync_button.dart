import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';

class SyncButton extends StatefulWidget {
  @override
  _SyncButtonState createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget<SyncState>(
      MainController.get().syncController.syncStateSV,
      (BuildContext context, SyncState syncState) {
        if (syncState == SyncState.SYNCING) {
          _animationController.repeat();
        } else {
          _animationController.stop();
          _animationController.reset();
        }
        return RotationTransition(
          turns: Tween(begin: 1.0, end: 0.0).animate(_animationController),
          child: IconButton(
            icon: Icon(syncState == SyncState.LAST_SYNC_FAILED ? Icons.sync_problem : Icons.sync),
            onPressed: syncState == SyncState.SYNCING
                ? null
                : () {
                    if (syncState == SyncState.SYNCING) {
                      return;
                    }
                    MainController.get().syncController.onClickSyncButton();
                  },
          ),
        );
      },
    );
  }
}
