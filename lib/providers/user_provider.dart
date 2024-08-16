import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _newUsers = [];

  List<UserModel> get newUsers => _newUsers;
  final List<UserModel> _filterednewUsers = [];

  UserProvider() {
    _loadnewUsers();
  }

  Future<void> _loadnewUsers() async {
    final snapshot = await _firestore.collection('newUsers').get();
    print(snapshot.docs.length);
    _newUsers =
        snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    print(_newUsers.length);
    _newUsers.sort(
        (a, b) => b.name!.compareTo(a.name!)); // Urutkan berdasarkan updatedAt
    _filterednewUsers.clear();

    notifyListeners();
  }

  Future<void> addUser(UserModel user) async {
    await _firestore.collection('newUsers').add(user.toMap());
    _loadnewUsers(); // Refresh the task list
  }

  Future<void> upateuser(UserModel user) async {
    await _firestore.collection('newUsers').doc(user.id).update(user.toMap());
    _loadnewUsers();
  }

  Future<void> deleteuser(String id) async {
    await _firestore.collection('newUsers').doc(id).delete();
    _loadnewUsers();
  }
}
