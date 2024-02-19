import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<model.User> getUserDetails() async {
     User user = _auth.currentUser!;
     DocumentSnapshot snap = await _firestore.collection('user')
         .doc(user.uid)
         .get();
     return model.User.fromSnap(snap);
   }

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error ocurred";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String url = await StorageMethods().uploadImageToStorage('profile_pic', file, false);
        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            photoUrl: url,
            username: username,
            bio: bio,
            followers: [],
            following: [],
        );
        await _firestore.collection('user').doc(cred.user!.uid).set(user.toJSON());
        res = 'success';
        return res;
      } else {
        print("please fill all the fields");
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error ocurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
        return res;
      } else {
        print("please fill all the fields");
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}
