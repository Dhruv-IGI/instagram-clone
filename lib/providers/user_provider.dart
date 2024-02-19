import 'package:flutter/material.dart';
import '../models/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user! ;
  // User get getUser => _user ?? User(
  //   username: "dfd",
  //   uid: 'snapshot["uid"]',
  //   email: 'snapshot["email"]',
  //   photoUrl: 'snapshot["photoUrl"]',
  //   bio: 'snapshot["bio"]',
  //   followers: [],
  //   following: [],
  // );

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = await user;
    notifyListeners();
  }
}