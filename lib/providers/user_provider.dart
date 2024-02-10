import 'package:chat_app/firebase/auth/auth_methods.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    _user = await AuthMethods().getUserDetails();
    notifyListeners();
  }
}
