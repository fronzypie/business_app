import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_firestore_service.dart';
import 'map_picker_screen.dart'; // Import the map picker screen
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  // TODO: Replace with actual logged-in owner id from auth
  final String _ownerId = 'owner1';
  final ItemFirestoreService _itemFirestoreService = ItemFirestoreService();
  List<Item> _items = [];
  bool _loadingItems = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() => _loadingItems = true);
    final items = await _itemFirestoreService.fetchItems();
    setState(() {
      _items = items.where((item) => item.ownerId == _ownerId).toList();
      _loadingItems = false;
    });
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descController.text,
      latitude: double.tryParse(_latController.text) ?? 0.0,
      longitude: double.tryParse(_lngController.text) ?? 0.0,
      ownerId: _ownerId,
    );
    await _itemFirestoreService.addItem(newItem);
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    _latController.clear();
    _lngController.clear();
    await _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // TODO: Implement actual logout logic (clear shared_preferences, etc.)
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.store, size: 44, color: Colors.deepPurple),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add New Item',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.deepPurple),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Item Name', prefixIcon: Icon(Icons.fastfood)),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price', prefixIcon: Icon(Icons.currency_rupee)),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _latController,
                  decoration: const InputDecoration(labelText: 'Latitude', prefixIcon: Icon(Icons.location_on)),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _lngController,
                  decoration: const InputDecoration(labelText: 'Longitude', prefixIcon: Icon(Icons.location_on_outlined)),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Pick Location on Map'),
                  onPressed: () async {
                    final LatLng? picked = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapPickerScreen(),
                      ),
                    );
                    if (picked != null) {
                      _latController.text = picked.latitude.toString();
                      _lngController.text = picked.longitude.toString();
                    }
                  },
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/owner_orders');
                  },
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('View Orders'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Your Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                const SizedBox(height: 8),
                _loadingItems
                    ? const Center(child: CircularProgressIndicator())
                    : _items.isEmpty
                        ? const Center(child: Text('No items yet.'))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _items.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.fastfood, color: Colors.deepPurple, size: 36),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(height: 4),
                                            Text('₹${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.deepPurple)),
                                            if (item.description.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(item.description, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                            ],
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on, size: 16, color: Colors.deepPurple),
                                                const SizedBox(width: 4),
                                                Text('(${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)})', style: const TextStyle(fontSize: 12, color: Colors.deepPurple)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                                  tooltip: 'Edit',
                                                  onPressed: () async {
                                                    final nameCtrl = TextEditingController(text: item.name);
                                                    final priceCtrl = TextEditingController(text: item.price.toString());
                                                    final descCtrl = TextEditingController(text: item.description);
                                                    final latCtrl = TextEditingController(text: item.latitude.toString());
                                                    final lngCtrl = TextEditingController(text: item.longitude.toString());
                                                    final result = await showDialog<Item>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Edit Item'),
                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                                                              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                                                              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
                                                              TextField(controller: latCtrl, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
                                                              TextField(controller: lngCtrl, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              final updated = Item(
                                                                id: item.id,
                                                                name: nameCtrl.text,
                                                                price: double.tryParse(priceCtrl.text) ?? 0.0,
                                                                description: descCtrl.text,
                                                                latitude: double.tryParse(latCtrl.text) ?? 0.0,
                                                                longitude: double.tryParse(lngCtrl.text) ?? 0.0,
                                                                ownerId: item.ownerId,
                                                              );
                                                              Navigator.pop(context, updated);
                                                            },
                                                            child: const Text('Save'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (result != null) {
                                                      await _itemFirestoreService.updateItem(result);
                                                      await _fetchItems();
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  tooltip: 'Delete',
                                                  onPressed: () async {
                                                    final messenger = ScaffoldMessenger.of(context);
                                                    try {
                                                      await _itemFirestoreService.deleteItem(item.id);
                                                      await _fetchItems();
                                                      if (!mounted) return;
                                                      messenger.showSnackBar(
                                                        const SnackBar(content: Text('Item deleted successfully')),
                                                      );
                                                    } catch (e) {
                                                      if (!mounted) return;
                                                      messenger.showSnackBar(
                                                        SnackBar(content: Text('Failed to delete item: $e')),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
