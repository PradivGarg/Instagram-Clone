import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:sociagram/Resources/storage_methods.dart';
import 'package:sociagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign-up the user
  Future<String> SignUpUser({
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
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoURL = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        //add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoURL: photoURL,
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJason());
        // (if you want to use add method without uid)await _firestore.collection('users').add({});
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res =
            'you have entered a weak password, please enter at least 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //log in a user with their credentials and get back token for
  // logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error has occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No such user");
      } else if (e.code == 'password-wrong') {
        print("Wrong Password");
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
