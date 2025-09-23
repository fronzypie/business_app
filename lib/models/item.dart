class Item {
  final String id;
  final String name;
  final double price;
  final String description;
  final double latitude;
  final double longitude;
  final String ownerId;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      ownerId: json['ownerId'] as String,
    );
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      ownerId: map['ownerId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
    };
  }
}
