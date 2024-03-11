import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rapido/ressources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        // register user
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential.user!.uid);
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "username": username,
          "uid": userCredential.user!.uid,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          'photoUrl': photoUrl,
        });

        res = "success";
      }
    } on FirebaseAuthException catch(err) {
      if(err.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if(err.code == 'email-already-in-use') {
        res = "The email address is already in use by another account.";
      } else if(err.code == 'weak-password') {
        res = "The password provided is too weak.";
      }
    } catch(err) {
      res = err.toString();
    }  
    return res;
  }
}