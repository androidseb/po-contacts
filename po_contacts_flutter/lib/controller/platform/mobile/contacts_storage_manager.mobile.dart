import 'dart:async';

import 'package:path/path.dart';
import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';
import 'package:sqflite/sqflite.dart';

class ContactsStorageManagerMobile implements ContactsStorageManager {
  static const String DB_FILE_NAME = 'contacts_database.db';
  static const String FIELD_ID = 'id';
  static const String FIELD_JSON = 'json';
  static const String TABLE_CONTACTS = 'contacts';

  final Future<Database> _database = _createDatabase();

  static Future<Database> _createDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), '$DB_FILE_NAME'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $TABLE_CONTACTS($FIELD_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $FIELD_JSON TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<ContactStorageEntryWithId>> readAllContacts() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('$TABLE_CONTACTS');
    return List.generate(maps.length, (i) {
      return ContactStorageEntryWithId(
        maps[i]['$FIELD_ID'],
        maps[i]['$FIELD_JSON'],
      );
    });
  }

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry) async {
    final Database db = await _database;
    final int insertedId = await db.insert(
      '$TABLE_CONTACTS',
      <String, String>{
        FIELD_JSON: storageEntry.json,
      },
    );
    return ContactStorageEntryWithId(insertedId, storageEntry.json);
  }

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry) async {
    final Database db = await _database;
    await db.update(
      '$TABLE_CONTACTS',
      <String, String>{
        FIELD_JSON: storageEntry.json,
      },
      where: '$FIELD_ID = ?',
      whereArgs: <int>[contactId],
    );
    return ContactStorageEntryWithId(contactId, storageEntry.json);
  }

  Future<bool> deleteContact(final int contactId) async {
    final Database db = await _database;
    final int deletedCount = await db.delete(
      '$TABLE_CONTACTS',
      where: '$FIELD_ID = ?',
      whereArgs: <int>[contactId],
    );
    return deletedCount == 1;
  }
}
