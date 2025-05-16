import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_static_model.dart';
import '../models/user_meta_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(String uid, UserStatic user, UserMeta meta) async {
    await _db.collection('users').doc(uid).set(user.toMap());
    await _db.collection('user_meta').doc(uid).set(meta.toMap());
  }

  Future<UserStatic?> getUserStatic(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserStatic.fromMap(doc.data()!);
    }
    return null;
  }

  Future<UserMeta?> getUserMeta(String uid) async {
    final doc = await _db.collection('user_meta').doc(uid).get();
    if (doc.exists) {
      return UserMeta.fromMap(doc.data()!);
    }
    return null;
  }
}
