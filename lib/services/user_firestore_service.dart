import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserFirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<List<AppUser>> fetchUsers() async {
    final snapshot = await users.get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addUser(AppUser user) async {
    await users.doc(user.id).set(user.toMap());
  }

  // Add more methods as needed (update, delete, etc.)
}
