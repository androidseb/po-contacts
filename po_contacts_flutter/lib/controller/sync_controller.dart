import 'dart:async';

import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/sync/data/remote_file.dart';
import 'package:po_contacts_flutter/controller/sync/google_drive_sync_interface.dart';
import 'package:po_contacts_flutter/controller/sync/sync_exception.dart';
import 'package:po_contacts_flutter/controller/sync/sync_interface.dart';
import 'package:po_contacts_flutter/controller/sync/sync_model.dart';
import 'package:po_contacts_flutter/controller/sync/sync_prodedure.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

class SyncController {
  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.IDLE);
  SyncState get syncState => _syncState.readOnly.currentValue;
  ReadOnlyStreamableValue<SyncState> get syncStateSV => _syncState.readOnly;
  final SyncModel _syncModel = SyncModel();
  SyncProcedure _currentSyncProcedure;

  Future<void> cancelSync() async {
    while (_syncState.currentValue == SyncState.SYNCING) {
      if (_currentSyncProcedure == null) {
        await Utils.yieldMainQueue();
      } else {
        _currentSyncProcedure.cancel();
        _currentSyncProcedure = null;
      }
    }
  }

  void onClickSyncButton() async {
    if (_syncState.currentValue == SyncState.SYNCING) {
      return;
    }
    _syncState.currentValue = SyncState.SYNCING;
    final bool syncSuccessful = await performSync(directUserAction: true);
    if (syncSuccessful) {
      _syncState.currentValue = SyncState.IDLE;
    } else {
      _syncState.currentValue = SyncState.LAST_SYNC_FAILED;
    }
  }

  Future<bool> performSync({bool directUserAction = false}) async {
    try {
      await _performSyncImpl(directUserAction: directUserAction);
      return true;
    } on SyncException catch (syncException) {
      _syncModel.updateLastSyncError(syncException);
    } catch (otherException) {
      _syncModel.updateLastSyncError(SyncException(SyncExceptionType.other, message: otherException.toString()));
    }
    return false;
  }

  Future<SyncInterface> _initializeSyncInterface() async {
    final SyncInterface syncInterface = GoogleDriveSyncInterface(_syncModel);
    final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
    if (!couldAuthenticateExplicitly) {
      throw SyncException(SyncExceptionType.authentication);
    }
    final List<RemoteFile> cloudIndexFiles = await syncInterface.fetchIndexFilesList();
    RemoteFile selectedCloudIndexFile;
    if (cloudIndexFiles.isNotEmpty) {
      final List<MultiSelectionChoice> selectionChoices = [];
      selectionChoices.add(MultiSelectionChoice(-1, I18n.getString(I18n.string.sync_to_new_file)));
      for (int i = 0; i < cloudIndexFiles.length; i++) {
        final RemoteFile cif = cloudIndexFiles[i];
        final Map<String, dynamic> indexFileContent = await syncInterface.getIndexFileContent(cif.fileId);
        if (indexFileContent == null) {
          continue;
        }
        selectionChoices.add(MultiSelectionChoice(i, '${indexFileContent[SyncInterface.INDEX_FILE_KEY_NAME]}'));
      }
      final MultiSelectionChoice selectedIndexFile =
          await MainController.get().promptMultiSelection(I18n.getString(I18n.string.cloud_sync), selectionChoices);
      if (selectedIndexFile == null) {
        return null;
      } else if (selectedIndexFile.entryId != -1) {
        selectedCloudIndexFile = cloudIndexFiles[selectedIndexFile.entryId];
      }
    }
    if (selectedCloudIndexFile == null) {
      selectedCloudIndexFile = await syncInterface.createNewIndexFile();
    }
    if (selectedCloudIndexFile == null) {
      return null;
    }
    await syncInterface.setSelectedCloudIndexFile(selectedCloudIndexFile);
    return syncInterface;
  }

  Future<SyncInterface> _getAuthenticatedSyncInterface({bool directUserAction = false}) async {
    SyncInterface syncInterface = await _syncModel.getCurrentSyncInterface();
    if (syncInterface == null) {
      syncInterface = await _initializeSyncInterface();
      if (syncInterface == null) {
        throw SyncException(SyncExceptionType.canceled);
      }
    } else {
      final bool couldAuthenticateImplicitly = await syncInterface.authenticateImplicitly();
      if (!couldAuthenticateImplicitly) {
        if (directUserAction) {
          final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
          if (!couldAuthenticateExplicitly) {
            throw SyncException(SyncExceptionType.authentication);
          }
        } else {
          throw SyncException(SyncExceptionType.authentication);
        }
      }
    }
    return syncInterface;
  }

  Future<void> _performSyncImpl({bool directUserAction = false}) async {
    SyncInterface syncInterface = await _getAuthenticatedSyncInterface(directUserAction: directUserAction);
    _currentSyncProcedure = SyncProcedure(syncInterface);
    await _currentSyncProcedure.execute();
    _currentSyncProcedure = null;
  }
}
