import '../services/order_firestore_service.dart';
import '../models/order.dart' as model;
import 'package:flutter/material.dart';
// import '../models/business.dart';

import '../services/item_firestore_service.dart';
import '../models/item.dart';
import 'package:geolocator/geolocator.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String searchQuery = '';
  String filter = 'None'; // 'None', 'Nearest', 'Price'
  double? userLat; // Real user location
  double? userLng;
  bool locationError = false;
  bool gettingLocation = false;
  late final ItemFirestoreService _itemFirestoreService;
  final OrderFirestoreService _orderFirestoreService = OrderFirestoreService();
  List<Item> _items = [];
  bool _loadingItems = true;

  @override
  void initState() {
    super.initState();
    _itemFirestoreService = ItemFirestoreService();
    _getUserLocation();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() => _loadingItems = true);
    final items = await _itemFirestoreService.fetchItems();
    setState(() {
      _items = items;
      _loadingItems = false;
    });
  }

  Future<void> _getUserLocation() async {
    setState(() {
      gettingLocation = true;
      locationError = false;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        setState(() {
          locationError = true;
          gettingLocation = false;
        });
        return;
      }
  final locSettings = const LocationSettings(accuracy: LocationAccuracy.high);
  Position pos = await Geolocator.getCurrentPosition(locationSettings: locSettings);
      setState(() {
        userLat = pos.latitude;
        userLng = pos.longitude;
        gettingLocation = false;
      });
    } catch (e) {
      setState(() {
        locationError = true;
        gettingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> allItems = List<Item>.from(_items);
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      allItems = allItems.where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    // Sort by filter
    if (filter == 'Price') {
      allItems.sort((a, b) => a.price.compareTo(b.price));
    } else if (filter == 'Nearest' && userLat != null && userLng != null) {
      allItems.sort((a, b) {
        double distA = ((a.latitude - userLat!) * (a.latitude - userLat!)) + ((a.longitude - userLng!) * (a.longitude - userLng!));
        double distB = ((b.latitude - userLat!) * (b.latitude - userLat!)) + ((b.longitude - userLng!) * (b.longitude - userLng!));
        return distA.compareTo(distB);
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Products')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            const SizedBox(height: 10),
            // Filter chips
            Row(
              children: [
                const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('None'),
                  selected: filter == 'None',
                  onSelected: (_) => setState(() => filter = 'None'),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Nearest'),
                  selected: filter == 'Nearest',
                  onSelected: (_) async {
                    setState(() => filter = 'Nearest');
                    if (userLat == null || userLng == null) {
                      await _getUserLocation();
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Price'),
                  selected: filter == 'Price',
                  onSelected: (_) => setState(() => filter = 'Price'),
                ),
              ],
            ),
            if (filter == 'Nearest' && (gettingLocation || userLat == null || userLng == null))
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(width: 10),
                    Text('Getting your location...'),
                  ],
                ),
              ),
            if (locationError)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Could not get your location. Please enable location permissions.', style: TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 10),
            const Text(
              'All Available Products',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loadingItems
                  ? const Center(child: CircularProgressIndicator())
                  : allItems.isEmpty
                      ? const Center(child: Text('No products available.'))
                      : ListView.builder(
                          itemCount: allItems.length,
                          itemBuilder: (context, index) {
                            final item = allItems[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(Icons.fastfood, color: Colors.deepPurple, size: 32),
                                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('₹${item.price.toStringAsFixed(2)}\n${item.description}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.shopping_cart_checkout, color: Colors.deepPurple),
                                  onPressed: () {
                                    String deliveryType = 'pickup';
                                    int quantity = 1;
                                    showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                        builder: (context, setState) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          title: Row(
                                            children: [
                                              const Icon(Icons.shopping_bag, color: Colors.deepPurple),
                                              const SizedBox(width: 8),
                                              Text('Order ${item.name}?'),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Price: ₹${item.price.toStringAsFixed(2)}'),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Text('Quantity:'),
                                                  IconButton(
                                                    icon: const Icon(Icons.remove),
                                                    onPressed: () {
                                                      if (quantity > 1) setState(() => quantity--);
                                                    },
                                                  ),
                                                  Text('$quantity'),
                                                  IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () => setState(() => quantity++),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              DropdownButtonFormField<String>(
                                                initialValue: deliveryType,
                                                decoration: const InputDecoration(labelText: 'Delivery Type'),
                                                items: const [
                                                  DropdownMenuItem(value: 'pickup', child: Text('Pickup')),
                                                  DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
                                                ],
                                                onChanged: (val) => setState(() => deliveryType = val ?? 'pickup'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                // TODO: Replace with real userId from auth
                                                final order = model.Order(
                                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                                  itemId: item.id,
                                                  userId: 'user1',
                                                  ownerId: item.ownerId,
                                                  quantity: quantity,
                                                  status: 'pending',
                                                  deliveryType: deliveryType,
                                                );
                                                final messenger = ScaffoldMessenger.of(context);
                                                final navigator = Navigator.of(context);
                                                try {
                                                  await _orderFirestoreService.addOrder(order);
                                                  if (!mounted) return;
                                                  navigator.pop();
                                                  messenger.showSnackBar(
                                                    SnackBar(content: Text('Order placed for ${item.name}!')),
                                                  );
                                                } catch (e) {
                                                  if (!mounted) return;
                                                  messenger.showSnackBar(
                                                    SnackBar(content: Text('Failed to place order: $e')),
                                                  );
                                                }
                                              },
                                              icon: const Icon(Icons.shopping_cart_checkout),
                                              label: const Text('Order'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
