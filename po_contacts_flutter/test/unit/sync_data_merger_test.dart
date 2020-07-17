import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_items_handler.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_result_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_data_merger.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_prodedure.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

const GENERATED_ID_STRING = 'GENERATED_ID';

class TestData {
  final String id;
  final String value;

  TestData(this.id, this.value);

  static List<String> testDataListToSortedStringList(final List<TestData> sourceList) {
    final List<String> result = [];
    for (final TestData td in sourceList) {
      result.add(td.id + '_' + td.value);
    }
    result.sort();
    return result;
  }
}

class TestSyncInitialData extends SyncInitialData<TestData> {
  TestSyncInitialData(
    final List<TestData> localItems,
    final List<TestData> lastSyncedItems,
    final List<TestData> remoteItems,
  ) : super(
          null,
          localItems,
          lastSyncedItems,
          remoteItems,
          true,
          null,
        );
}

class TestSyncItemsHandler extends SyncItemsHandler<TestData> {
  @override
  TestData cloneItemWithNewId(final TestData item) {
    return TestData(GENERATED_ID_STRING, item.value);
  }

  @override
  String getItemId(final TestData item) {
    return item.id;
  }

  @override
  bool itemsEqualExceptId(final TestData item1, TestData item2) {
    return item1.value == item2.value;
  }
}

class TestSyncDataMerger extends SyncDataMerger<TestData> {
  TestSyncDataMerger(
    final TestSyncInitialData syncInitialData,
    final TestSyncItemsHandler itemsHandler,
    final SyncCancelationHandler cancelationHandler,
  ) : super(
          syncInitialData,
          itemsHandler,
          cancelationHandler,
        );
}

void testSyncDataMerger({
  @required final List<TestData> localItems,
  @required final List<TestData> lastSyncedItems,
  @required final List<TestData> remoteItems,
  @required final List<TestData> expectedSyncResultData,
  @required final bool expectedHasLocalChangesValue,
  @required final bool expectedHasRemoteChangesValue,
}) async {
  final SyncResultData<TestData> syncResult = await TestSyncDataMerger(
    TestSyncInitialData(
      localItems,
      lastSyncedItems,
      remoteItems,
    ),
    TestSyncItemsHandler(),
    SyncCancelationHandler(),
  ).computeSyncResult();
  try {
    expect(syncResult.hasLocalChanges, expectedHasLocalChangesValue);
  } catch (e) {
    print('syncResult.hasLocalChanges: ${syncResult.hasLocalChanges}');
    print('expectedHasLocalChangesValue: ${expectedHasLocalChangesValue}');
    throw e;
  }
  try {
    expect(syncResult.hasRemoteChanges, expectedHasRemoteChangesValue);
  } catch (e) {
    print('syncResult.hasRemoteChanges: ${syncResult.hasRemoteChanges}');
    print('expectedHasRemoteChangesValue: ${expectedHasRemoteChangesValue}');
    throw e;
  }
  final List<String> syncResultDataAsStringsList = TestData.testDataListToSortedStringList(syncResult.syncResultData);
  final List<String> expectedSyncResultDataAsStringsList =
      TestData.testDataListToSortedStringList(expectedSyncResultData);
  try {
    expect(Utils.areListsEqual(syncResultDataAsStringsList, expectedSyncResultDataAsStringsList), true);
  } catch (e) {
    print('actual sync result:   $syncResultDataAsStringsList');
    print('expected sync result: $expectedSyncResultDataAsStringsList');
    throw e;
  }
}

void main() {
  test('Can merge no changes empty', () async {
    testSyncDataMerger(
      localItems: [],
      lastSyncedItems: [],
      remoteItems: [],
      expectedSyncResultData: [],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: false,
    );
  });
  test('Can merge no changes with same data same ids', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can merge no changes with same data different ids', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('2', 'A'), TestData('3', 'B')],
      expectedSyncResultData: [TestData('2', 'A'), TestData('3', 'B')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can handle local addition changes with initially empty dataset', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A')],
      lastSyncedItems: [],
      remoteItems: [],
      expectedSyncResultData: [TestData('0', 'A')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can handle local addition changes with initially non-empty dataset', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can handle local modification changes', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A2'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can handle local deletion changes with items remaining', () async {
    testSyncDataMerger(
      localItems: [TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('1', 'B')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can handle local deletion changes with no items remaining', () async {
    testSyncDataMerger(
      localItems: [],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B')],
      expectedSyncResultData: [],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can handle remote addition changes with initially non-empty dataset', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can handle remote addition changes with initially empty dataset', () async {
    testSyncDataMerger(
      localItems: [],
      lastSyncedItems: [],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can handle remote modification changes', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can handle remote deletion changes with items remaining', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('1', 'B')],
      expectedSyncResultData: [TestData('1', 'B')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can handle remote deletion changes with no items remaining', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [],
      expectedSyncResultData: [],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can merge local and remote changes without conflict (addition/addition)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('3', 'D')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C'), TestData('3', 'D')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (addition/modification)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B2')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B2'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (addition/deletion)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (modification/addition)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B2')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B2'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (modification/deletion)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A2'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A')],
      expectedSyncResultData: [TestData('0', 'A2')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (deletion/addition)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (deletion/modification)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A2')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (deletion/deletion) with no items remaining', () async {
    testSyncDataMerger(
      localItems: [TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A')],
      expectedSyncResultData: [],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes without conflict (deletion/deletion) with some items remaining', () async {
    testSyncDataMerger(
      localItems: [TestData('1', 'B'), TestData('2', 'C')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B'), TestData('2', 'C')],
      remoteItems: [TestData('0', 'A'), TestData('2', 'C')],
      expectedSyncResultData: [TestData('2', 'C')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes with conflict of (modification/deletion)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A2'), TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedHasLocalChangesValue: false,
      expectedHasRemoteChangesValue: true,
    );
  });

  test('Can merge local and remote changes with conflict of (deletion/modification)', () async {
    testSyncDataMerger(
      localItems: [TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedSyncResultData: [TestData('0', 'A2'), TestData('1', 'B')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can merge local and remote changes with conflict of (deletion/deletion)', () async {
    testSyncDataMerger(
      localItems: [TestData('1', 'B')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('1', 'B')],
      expectedSyncResultData: [TestData('1', 'B')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: false,
    );
  });

  test('Can merge local and remote changes without conflict (modification/modification)', () async {
    testSyncDataMerger(
      localItems: [TestData('0', 'A'), TestData('1', 'B2')],
      lastSyncedItems: [TestData('0', 'A'), TestData('1', 'B')],
      remoteItems: [TestData('0', 'A'), TestData('1', 'B3')],
      expectedSyncResultData: [TestData('0', 'A'), TestData('1', 'B3'), TestData(GENERATED_ID_STRING, 'B2')],
      expectedHasLocalChangesValue: true,
      expectedHasRemoteChangesValue: true,
    );
  });
}
