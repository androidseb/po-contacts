import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/disk_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';

class POCSyncController extends SyncController<Contact> {
  static const SYNC_FOLDER_NAME = 'cloud_sync';

  @override
  Future<int> pickIndexFile(final List<String> cloudIndexFileNames) async {
    final List<MultiSelectionChoice> selectionChoices = [];
    selectionChoices.add(MultiSelectionChoice(-1, I18n.getString(I18n.string.sync_to_new_file)));
    for (int i = 0; i < cloudIndexFileNames.length; i++) {
      final String indexFileName = cloudIndexFileNames[i];
      selectionChoices.add(MultiSelectionChoice(i, indexFileName));
    }
    final MultiSelectionChoice selectedIndexFile =
        await MainController.get().promptMultiSelection(I18n.getString(I18n.string.cloud_sync), selectionChoices);
    if (selectedIndexFile == null) {
      return null;
    } else {
      return selectedIndexFile.entryId;
    }
  }

  @override
  SyncInterfaceConfig getSyncInterfaceConfig() {
    return SyncInterfaceConfig(
      'pocontacts',
      'po_contacts_index.json',
    );
  }

  @override
  Future<List<Contact>> getLocalItems() async {
    final List<Contact> localContacts = [];
    localContacts.addAll(MainController.get().model.contactsList);
    return localContacts;
  }

  @override
  Future<List<Contact>> fileEntityToItemsList(
    final FileEntity fileEntity,
    final String encryptionKey,
  ) async {
    if (fileEntity == null) {
      return [];
    }
    final List<Contact> res = [];
    final List<ContactBuilder> lastSyncedContacts = await VCFSerializer.readFromVCF(
      VCFFileReader(
        fileEntity,
        encryptionKey,
        DiskFileInflater(),
      ),
    );
    int counter = 0;
    for (final ContactBuilder cb in lastSyncedContacts) {
      res.add(cb.build(counter++));
    }
    return res;
  }

  Future<String> _getSyncFolderPath() async {
    final String homeDirPath =
        await MainController.get().psController.filesManager.getApplicationDocumentsDirectoryPath();
    return '$homeDirPath/$SYNC_FOLDER_NAME';
  }

  @override
  Future<FileEntity> fileEntityByName(final String fileName) async {
    final String syncFolderPath = await _getSyncFolderPath();
    return MainController.get().psController.filesManager.createFileEntityParentAndName(syncFolderPath, fileName);
  }
}
