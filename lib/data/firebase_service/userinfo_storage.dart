import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({
    required String email,
    required String username,
  }) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email': email,
      'username': username,
    });
    return true;
  }
}
