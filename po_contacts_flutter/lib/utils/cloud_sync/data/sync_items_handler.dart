abstract class SyncItemsHandler<T> {
  String getItemId(final T item);
  T cloneItemWithNewId(final T item);
  bool itemsEqualExceptId(final T? item1, final T? item2);
}
