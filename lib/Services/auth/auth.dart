import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final DatabaseReference uidRef = FirebaseDatabase.instance.ref('post/uid');
  final DatabaseReference ctrRef = FirebaseDatabase.instance.ref('counter');

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
      return 'okay nigga $e';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> uidPostData(int ctr, String action, String formatDate,
      String formatTime, String uid, String location) async {
    await uidRef.child("$uid/$ctr").set({
      'location': location,
      'action': action,
      'date': formatDate,
      'time': formatTime,
    });
  }

  Future<void> tryData() async {
    DatabaseReference dateRef = FirebaseDatabase.instance.ref("post/uid/");
    DatabaseEvent event = await dateRef.once();
  }
}
