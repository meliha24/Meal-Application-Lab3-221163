import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = "test_user";

  Future<List<FavoriteMeal>> getFavorites() async {
    final snapshot = await _firestore.collection('users/$_userId/favorites').get();
    return snapshot.docs.map((doc) => FavoriteMeal.fromMap(doc.data())).toList();
  }

  Future<void> addFavorite(FavoriteMeal meal) async {
    await _firestore.collection('users/$_userId/favorites').doc(meal.id).set(meal.toMap());
  }

  Future<void> removeFavorite(FavoriteMeal meal) async {
    await _firestore.collection('users/$_userId/favorites').doc(meal.id).delete();
  }
}
