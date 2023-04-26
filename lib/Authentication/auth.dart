import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The UID of the newly registered user can be obtained from the UserCredential object
      String uid = userCredential.user!.uid;
      return uid;
    } catch (e) {
      // Handle errors that occurred during registration
      print(e.toString());
      return '';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
