import 'dart:convert';

import 'package:flutter_task_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String _keyLoggedIn = 'logged_in';
  static const String _keyUser = 'user';

  // Simpan status login
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyLoggedIn, value);
  }

  // Ambil status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> setUser(UserModel value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUser, jsonEncode(value.toMap()));
  }

  static Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return UserModel.fromMap(jsonDecode(prefs.getString(_keyUser)!));
  }
}
