import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        final doc = await _firestore.collection('users').doc(result.user!.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        final user = UserModel(
          uid: result.user!.uid,
          name: name,
          email: email,
          role: 'citizen',
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(user.toMap());
        return user;
      }
      return null;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      if (result.user != null) {
        final doc = await _firestore.collection('users').doc(result.user!.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        } else {
          final user = UserModel(
            uid: result.user!.uid,
            name: result.user!.displayName ?? 'User',
            email: result.user!.email ?? '',
            role: 'citizen',
            createdAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(user.uid).set(user.toMap());
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }
}
