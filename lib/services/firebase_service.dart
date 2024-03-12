import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFirebaseAuth {

  late final FirebaseAuth _firebaseAuth;

  MyFirebaseAuth() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User? get getCurrentUser => _firebaseAuth.currentUser;

  Future<FirebaseException?> signUpUser(String email, String studentID, String password, String phone) async {
    try {
      UserCredential usercredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection("users").doc(usercredential.user!.uid).set({
        "uid": usercredential.user!.uid,
        "sid": studentID,
        "email": email,
        "phone": phone
      });
      return null;
    }
    on FirebaseException catch (error) {
      return error;
    }
  }

  Future<FirebaseException?> signInUser(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }
    on FirebaseException catch (error) {
      return error;
    }
  }

  Future<FirebaseException?> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return null;
    }
    on FirebaseException catch (error) {
      return error;
    }
  }

  Future<FirebaseException?> signUpVendor(String email, String restaurantName, String password, String location, String workingHours, String description, String imageUrl, String phone) async {
    try {
      UserCredential usercredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection("restaurants").doc(usercredential.user!.uid).set({
        "name": restaurantName,
        "email": email,
        "location": location,
        "workingHours": workingHours,
        "description": description,
        "image": imageUrl,
        "phone": phone
      });
      return null;
    }
    on FirebaseException catch (error) {
      return error;
    }
  }

  Future<FirebaseException?> requestPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    }
    on FirebaseException catch (error) {
      return error;
    }
  }
}