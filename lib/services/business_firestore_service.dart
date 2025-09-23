import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business.dart';

class BusinessFirestoreService {
  final CollectionReference businesses = FirebaseFirestore.instance.collection('businesses');

  Future<List<Business>> fetchBusinesses() async {
    final snapshot = await businesses.get();
    return snapshot.docs.map((doc) => Business.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addBusiness(Business business) async {
    await businesses.doc(business.id).set(business.toMap());
  }

  // Add more methods as needed (update, delete, etc.)
}
