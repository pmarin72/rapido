import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rapido/models/user.dart' as model;
import 'package:rapido/ressources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

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
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to firestore
        model.User user = model.User(
          uid: userCredential.user!.uid,
          email: email,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if (err.code == 'email-already-in-use') {
        res = "The email address is already in use by another account.";
      } else if (err.code == 'weak-password') {
        res = "The password provided is too weak.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter email and password";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if (err.code == 'user-not-found') {
        res =
            "There is no user record corresponding to this identifier. The user may have been deleted.";
      } else if (err.code == 'wrong-password') {
        res = "The password is invalid or the user does not have a password.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
