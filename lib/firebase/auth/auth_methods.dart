import 'dart:typed_data';

import 'package:chat_app/firebase/storage/storage_method.dart';
import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromDocumentSnapshot(snap);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List dp}) async {
    String res = "Some errors occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user
        UserCredential userCredentails = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        //save user credentials
        if (userCredentails.user == null) {
          res =
              "An error occured,your account was not created. Please try again";
          return res;
        }

        //save user profile pic to firebase storage
        String dpUrl =
            await StorageMethods().uploadFileToFirebaseStorage("dp", dp, false);

        UserModel user = UserModel(
            username: username,
            email: email,
            bio: bio,
            uid: userCredentails.user!.uid,
            followers: [],
            following: [],
            dpUrl: dpUrl);

        await _firestore
            .collection('users')
            .doc(userCredentails.user!.uid)
            .set(user.toJson());
        res = "success";
      } else {
        return res = "Please provide all the required fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some errors occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      } else {
        return res = "Please provide all the required fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
