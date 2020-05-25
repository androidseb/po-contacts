import 'dart:async';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface_google_drive.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_prodedure.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

abstract class SyncController<T> {
  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.IDLE);
  SyncState get syncState => _syncState.readOnly.currentValue;
  ReadOnlyStreamableValue<SyncState> get syncStateSV => _syncState.readOnly;
  final SyncModel _syncModel = SyncModel();
  SyncProcedure _currentSyncProcedure;

  SyncInterfaceConfig getSyncInterfaceConfig();

  Future<List<T>> getLocalItems();

  Future<List<T>> fileEntityToItemsList(
    final FileEntity fileEntity,
    final String encryptionKey,
  );

  /// Select a cloud index file based on the name of that index file
  /// Returns 3 possible types of value:
  /// * the index of the user's choice
  /// * -1 if the user chose to create a new index
  /// * null if the user canceled
  Future<int> pickIndexFile(final List<String> cloudIndexFileNames);

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
      _syncModel.updateLastSyncError(SyncException(SyncExceptionType.OTHER, message: otherException.toString()));
    }
    return false;
  }

  Future<SyncInterface> _initializeSyncInterface() async {
    final SyncInterface syncInterface = SyncInterfaceForGoogleDrive(getSyncInterfaceConfig(), _syncModel);
    final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
    if (!couldAuthenticateExplicitly) {
      throw SyncException(SyncExceptionType.AUTHENTICATION);
    }
    final List<RemoteFile> cloudIndexFiles = await syncInterface.fetchIndexFilesList();
    RemoteFile selectedCloudIndexFile;
    if (cloudIndexFiles.isNotEmpty) {
      final List<String> indexFileNames = [];
      for (final RemoteFile cif in cloudIndexFiles) {
        final Map<String, dynamic> indexFileContent = await syncInterface.getIndexFileContent(cif.fileId);
        if (indexFileContent != null && indexFileContent[SyncInterface.INDEX_FILE_KEY_NAME] != null) {
          indexFileNames.add(indexFileContent[SyncInterface.INDEX_FILE_KEY_NAME]);
        } else {
          indexFileNames.add('???');
        }
      }
      final int indexFileChoiceIndex = await pickIndexFile(indexFileNames);
      if (indexFileChoiceIndex == null) {
        return null;
      } else if (indexFileChoiceIndex != -1) {
        selectedCloudIndexFile = cloudIndexFiles[indexFileChoiceIndex];
      }
    }
    if (selectedCloudIndexFile == null) {
      selectedCloudIndexFile = await syncInterface.createNewIndexFile();
    }
    if (selectedCloudIndexFile == null) {
      return null;
    }
    await syncInterface.setCloudIndexFileId(selectedCloudIndexFile.fileId);
    return syncInterface;
  }

  Future<SyncInterface> _getAuthenticatedSyncInterface({bool directUserAction = false}) async {
    SyncInterface syncInterface = await _syncModel.getCurrentSyncInterface(getSyncInterfaceConfig());
    if (syncInterface == null) {
      syncInterface = await _initializeSyncInterface();
      if (syncInterface == null) {
        throw SyncException(SyncExceptionType.CANCELED);
      }
    } else {
      final bool couldAuthenticateImplicitly = await syncInterface.authenticateImplicitly();
      if (!couldAuthenticateImplicitly) {
        if (directUserAction) {
          final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
          if (!couldAuthenticateExplicitly) {
            throw SyncException(SyncExceptionType.AUTHENTICATION);
          }
        } else {
          throw SyncException(SyncExceptionType.AUTHENTICATION);
        }
      }
    }
    return syncInterface;
  }

  Future<void> _performSyncImpl({bool directUserAction = false}) async {
    final SyncInterface syncInterface = await _getAuthenticatedSyncInterface(directUserAction: directUserAction);
    _currentSyncProcedure = SyncProcedure(this, syncInterface);
    await _currentSyncProcedure.execute();
    _currentSyncProcedure = null;
  }
}
