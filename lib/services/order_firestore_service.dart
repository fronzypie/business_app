import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as model;

class OrderFirestoreService {
  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<List<model.Order>> fetchOrders() async {
    final snapshot = await orders.get();
    return snapshot.docs.map((doc) => model.Order.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Stream<List<model.Order>> ordersStream() {
    return orders.snapshots().map((snapshot) => snapshot.docs.map((doc) => model.Order.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addOrder(model.Order order) async {
    await orders.doc(order.id).set(order.toMap());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await orders.doc(orderId).update({'status': status});
  }

  // Add more methods as needed (update, delete, etc.)
}
