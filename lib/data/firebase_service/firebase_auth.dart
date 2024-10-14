import 'package:chico_ff/data/firebase_service/userinfo_storage.dart';
import 'package:chico_ff/util/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  } 

  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirm,
    required String username,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        if (password == passwordConfirm) {
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

          // get user info with firestore
          await UserInfoStorage().CreateUser(email: email, username: username);

        } else {
          throw exceptions('Password does not match');
        }
      } else {
        throw exceptions('enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
