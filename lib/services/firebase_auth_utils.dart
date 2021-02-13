import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFunc{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<User> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> emailVerified();
}

class MyAuth implements AuthFunc{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> getCurrentUser() async {
    return await _firebaseAuth.currentUser;
  }

  @override
  Future<bool> emailVerified() async{
    var user = await _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async{
    var user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    var user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<String> signUp(String email, String password) async{
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

}