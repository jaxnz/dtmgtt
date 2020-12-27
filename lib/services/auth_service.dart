import 'package:firebase_auth/firebase_auth.dart';
import 'package:dtmgtt/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(userFromFirebaseUser);
  }

  //sign out
  Future signOut() async {
    return await _auth.signOut();
  }

  //forgot password
  Future forgotPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}