import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUserScope {
  FirestoreUserScope._();

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static User get currentUser {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    return user;
  }

  static String get uid => currentUser.uid;

  static DocumentReference<Map<String, dynamic>> get userDoc {
    return firestore.collection('users').doc(uid);
  }

  static CollectionReference<Map<String, dynamic>> get itemsCollection {
    return userDoc.collection('items');
  }

  static CollectionReference<Map<String, dynamic>> get transactionsCollection {
    return userDoc.collection('transactions');
  }

  static Future<bool> isUserLoggedIn() async {
    return auth.currentUser != null;
  }
}