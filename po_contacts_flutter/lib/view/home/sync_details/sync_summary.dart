import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class SyncSummary extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return StreamedWidget<SyncState>(
      MainController.get().syncController.syncStateSV,
      (final BuildContext context, final SyncState syncState) {
        return _buildFromSyncState(context);
      },
    );
  }

  IconData _getIconData(final SyncController syncController) {
    if (syncController.model?.cloudIndexFileId == null) {
      return Icons.cloud_off;
    } else if (syncController.syncState == SyncState.SYNC_IN_PROGRESS ||
        syncController.syncState == SyncState.SYNC_CANCELING) {
      return Icons.more_horiz;
    } else if (syncController.model?.hasLocalChanges == true) {
      return Icons.cloud_upload;
    } else if (syncController.model?.hasRemoteChanges == true) {
      return Icons.cloud_download;
    } else {
      return Icons.cloud_done;
    }
  }

  String _getTopText(final SyncController syncController) {
    final String cloudIndexFileId = syncController.model?.cloudIndexFileId;
    final String accountName = syncController.model?.accountName;
    if (cloudIndexFileId == null || accountName == null) {
      return I18n.getString(I18n.string.cloud_sync_off);
    } else {
      return accountName;
    }
  }

  String _getLastSyncTimeString(final SyncController syncController) {
    final int lastSyncTimeEpochMillis = syncController.model?.lastSyncTimeEpochMillis;
    if (lastSyncTimeEpochMillis == null) {
      return I18n.getString(I18n.string.last_sync_time_never);
    } else {
      return Utils.dateTimeToHumanShortString(lastSyncTimeEpochMillis);
    }
  }

  String _getSyncButtonText(final SyncController syncController) {
    String syncButtonStringKey;
    if (syncController.syncState == SyncState.SYNC_IN_PROGRESS) {
      syncButtonStringKey = I18n.string.cloud_sync_cancel;
    } else if (syncController.model?.cloudIndexFileId == null) {
      syncButtonStringKey = I18n.string.cloud_sync_sync;
    } else if (syncController.syncState == SyncState.SYNC_CANCELING) {
      syncButtonStringKey = I18n.string.cloud_sync_canceling;
    } else {
      syncButtonStringKey = I18n.string.cloud_sync_options;
    }
    return I18n.getString(syncButtonStringKey).toUpperCase();
  }

  Function _getSyncButtonAction(final SyncController syncController) {
    if (syncController.syncState == SyncState.SYNC_CANCELING) {
      return null;
    }
    if (syncController.model?.cloudIndexFileId == null) {
      if (syncController.syncState == SyncState.SYNC_IN_PROGRESS) {
        return null;
      }
      return () {
        MainController.get().syncController.startSync();
      };
    } else if (syncController.syncState == SyncState.SYNC_IN_PROGRESS) {
      return () {
        MainController.get().syncController.cancelSync();
      };
    } else {
      return () {
        MainController.get().syncController.showSyncOptionsMenu();
      };
    }
  }

  Widget _buildFromSyncState(final BuildContext context) {
    final SyncController syncController = MainController.get().syncController;
    final IconData syncIconData = _getIconData(syncController);
    final String syncStatusTopText = _getTopText(syncController);
    final String lastSyncTimeString = _getLastSyncTimeString(syncController);
    final String syncStatusBottomText = I18n.getString(I18n.string.last_sync_time_x, lastSyncTimeString);
    final String syncButtonText = _getSyncButtonText(syncController);
    final Function syncButtonAction = _getSyncButtonAction(syncController);
    return Column(
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          leading: Icon(syncIconData),
          title: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(syncStatusTopText),
                SizedBox(height: 8),
                Text(syncStatusBottomText),
              ],
            ),
          ),
          subtitle: ElevatedButton(
            child: Text(syncButtonText),
            onPressed: syncButtonAction,
          ),
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
