import '../models/business.dart';

class BusinessService {
  static final List<Business> _demoBusinesses = [
    Business(
      id: 'b1',
      name: 'Cafe Aroma',
      category: 'Cafe',
      address: '123 Main St',
      description: 'Cozy cafe with fresh brews and pastries.',
      latitude: 28.6139,
      longitude: 77.2090,
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    ),
    Business(
      id: 'b2',
      name: 'Beauty Bliss',
      category: 'Beauty',
      address: '456 Park Ave',
      description: 'Salon and spa for all your beauty needs.',
      latitude: 28.6140,
      longitude: 77.2100,
      imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
    ),
    Business(
      id: 'b4',
      name: 'Techie Electronics',
      category: 'Electronics',
      address: '101 Tech Park',
      description: 'Latest gadgets and electronics.',
      latitude: 28.6160,
      longitude: 77.2120,
      imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=400&q=80',
    ),
    Business(
      id: 'b5',
      name: 'Green Grocers',
      category: 'Grocery',
      address: '202 Market Lane',
      description: 'Fresh fruits and vegetables daily.',
      latitude: 28.6170,
      longitude: 77.2130,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  static Future<List<Business>> getBusinesses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    return _demoBusinesses;
  }
}
