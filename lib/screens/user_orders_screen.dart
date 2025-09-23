import 'package:flutter/material.dart';
import '../services/order_firestore_service.dart';
import '../models/order.dart' as model;

class UserOrdersScreen extends StatefulWidget {
  final String userId;
  const UserOrdersScreen({super.key, required this.userId});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  final OrderFirestoreService _orderFirestoreService = OrderFirestoreService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<model.Order>>(
        stream: _orderFirestoreService.ordersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = (snapshot.data ?? []).where((o) => o.userId == widget.userId).toList();
          if (orders.isEmpty) return const Center(child: Text('No orders yet.'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text('Item: ${order.itemId}\nQty: ${order.quantity}\nType: ${order.deliveryType}\nStatus: ${order.status}'),
              );
            },
          );
        },
      ),
    );
  }
}
