

class Order {
  final String id;
  final String itemId;
  final String userId;
  final String ownerId;
  final int quantity;
  final String status; // pending, accepted, completed
  final String deliveryType; // pickup or delivery

  Order({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.ownerId,
    required this.quantity,
    required this.status,
    required this.deliveryType,
  });
}

class OrderService {
  static final List<Order> _orders = [];

  static void placeOrder(Order order) {
    _orders.add(order);
  }

  static List<Order> getOrdersForOwner(String ownerId) {
    return _orders.where((o) => o.ownerId == ownerId).toList();
  }

  static List<Order> getOrdersForUser(String userId) {
    return _orders.where((o) => o.userId == userId).toList();
  }

  static void updateOrderStatus(String orderId, String status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = Order(
        id: _orders[idx].id,
        itemId: _orders[idx].itemId,
        userId: _orders[idx].userId,
        ownerId: _orders[idx].ownerId,
        quantity: _orders[idx].quantity,
        status: status,
        deliveryType: _orders[idx].deliveryType,
      );
    }
  }
}
