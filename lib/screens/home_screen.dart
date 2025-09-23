import 'package:flutter/material.dart';
import '../models/business.dart';
import '../services/business_firestore_service.dart';
import '../widgets/business_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Cafe', 'Beauty', 'Fitness'];
  final BusinessFirestoreService _businessFirestoreService = BusinessFirestoreService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Local'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            const Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade50,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nearby Businesses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Business>>(
                future: _businessFirestoreService.fetchBusinesses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: \\${snapshot.error}'),
                    );
                  } else {
                    final businesses = snapshot.data!;
                    final filteredBusinesses = selectedCategory == 'All'
                        ? businesses
                        : businesses.where((b) => b.category == selectedCategory).toList();
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredBusinesses.length,
                      itemBuilder: (context, index) {
                        final business = filteredBusinesses[index];
                        return BusinessCard(business: business);
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/browse');
                },
                icon: const Icon(Icons.search),
                label: const Text('Browse Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade50,
                  foregroundColor: Colors.deepPurple,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/user_orders');
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('My Orders'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ...existing code...
