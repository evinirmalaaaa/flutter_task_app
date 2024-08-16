import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_model.dart';

class NewTaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;
  final List<TaskModel> _filteredTasks = [];

  NewTaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final snapshot = await _firestore.collection('newtasks').get();
    _tasks = snapshot.docs.map((doc) => TaskModel.fromDocument(doc)).toList();
    _tasks.sort((a, b) =>
        b.updatedAt.compareTo(a.updatedAt)); // Urutkan berdasarkan updatedAt
    _filteredTasks.clear();

    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('newtasks').add(task.toMap());
    _loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('newtasks').doc(task.id).update(task.toMap());
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('newtasks').doc(id).delete();
    _loadTasks();
  }

  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _firestore.collection('newtasks').doc(id).update({
      'isCompleted': isCompleted,
      'updatedAt': DateTime.now().toIso8601String(), // Update updatedAt
    });
    _loadTasks();
  }
}
