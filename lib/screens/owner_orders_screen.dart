import 'package:flutter/material.dart';
import '../services/order_firestore_service.dart';
import '../models/order.dart' as model;

class OwnerOrdersScreen extends StatefulWidget {
  final String ownerId;
  const OwnerOrdersScreen({super.key, required this.ownerId});

  @override
  State<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends State<OwnerOrdersScreen> {
  final OrderFirestoreService _orderFirestoreService = OrderFirestoreService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming Orders')),
      body: StreamBuilder<List<model.Order>>(
        stream: _orderFirestoreService.ordersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = (snapshot.data ?? []).where((o) => o.ownerId == widget.ownerId).toList();
          if (orders.isEmpty) return const Center(child: Text('No orders yet.'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text('Item: ${order.itemId}\nQty: ${order.quantity}\nType: ${order.deliveryType}\nStatus: ${order.status}'),
                trailing: order.status == 'completed'
                    ? const Text('Completed', style: TextStyle(color: Colors.green))
                    : ElevatedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text('Mark this order as completed?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes')),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          try {
                            await _orderFirestoreService.updateOrderStatus(order.id, 'completed');
                            if (!mounted) return;
                            messenger.showSnackBar(const SnackBar(content: Text('Order marked completed')));
                          } catch (e) {
                            if (!mounted) return;
                            messenger.showSnackBar(SnackBar(content: Text('Failed to update order: $e')));
                          }
                        },
                        child: const Text('Mark completed'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
