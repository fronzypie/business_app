
import '../models/item.dart';

class ItemService {
  // In-memory storage for demonstration. Replace with persistent storage as needed.
  static final Map<String, List<Item>> _ownerItems = {};

  static List<Item> get allItems {
    return _ownerItems.values.expand((items) => items).toList();
  }

  static List<Item> getItemsForOwner(String ownerId) {
    return _ownerItems[ownerId] ?? [];
  }

  static void addItemForOwner(String ownerId, Item item) {
    if (_ownerItems[ownerId] == null) {
      _ownerItems[ownerId] = [];
    }
    _ownerItems[ownerId]!.add(item);
  }

  static void removeItemForOwner(String ownerId, String itemId) {
    _ownerItems[ownerId]?.removeWhere((item) => item.id == itemId);
  }

  static void updateItemForOwner(String ownerId, Item updatedItem) {
    final items = _ownerItems[ownerId];
    if (items == null) return;
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
    }
  }
}
