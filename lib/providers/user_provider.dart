import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../helpers/database_helper.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> loadUser() async {
    _user = await DatabaseHelper.instance.getUser();
    notifyListeners();
  }
}
