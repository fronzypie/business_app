class Order {
  final String id;
  final String itemId;
  final String userId;
  final String ownerId;
  final int quantity;
  final String status;
  final String deliveryType;

  Order({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.ownerId,
    required this.quantity,
    required this.status,
    required this.deliveryType,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      itemId: map['itemId'] as String,
      userId: map['userId'] as String,
      ownerId: map['ownerId'] as String,
      quantity: map['quantity'] as int,
      status: map['status'] as String,
      deliveryType: map['deliveryType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'userId': userId,
      'ownerId': ownerId,
      'quantity': quantity,
      'status': status,
      'deliveryType': deliveryType,
    };
  }
}
