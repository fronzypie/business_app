import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemFirestoreService {
  final CollectionReference items = FirebaseFirestore.instance.collection('items');

  Future<List<Item>> fetchItems() async {
    final snapshot = await items.get();
    return snapshot.docs.map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addItem(Item item) async {
    await items.doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(Item item) async {
    await items.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await items.doc(itemId).delete();
  }
}
