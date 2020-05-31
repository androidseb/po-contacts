abstract class SyncDataInfoProvider<T> {
  String getItemId(final T item);

  bool itemsEqualExceptId(final T item1, final T item2);
}
