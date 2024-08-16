import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/models/user_model.dart';

class MemberProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _users = [];

  List<UserModel> get users => _users;
  final List<UserModel> _filteredusers = [];

  MemberProvider() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final snapshot = await _firestore.collection('newUsers').get();
    _users = snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    _users.sort((a, b) =>
        b.updatedAt!.compareTo(a.updatedAt!)); // Urutkan berdasarkan updatedAt
    _filteredusers.clear();

    notifyListeners();
  }
}
