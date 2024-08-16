import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/models/user_model.dart';

class TaskModel {
  final String? id;
  final String name;
  final String description;
  final String category;
  final List<UserModel> members;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String priority;
  bool isCompleted;

  TaskModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.members,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.isCompleted = false,
  });

  // Method to convert Task to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted, // Sertakan isCompleted
      'members': members.map((member) => member.toMap()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Method to create Task from Map (for Firestore)
  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    return TaskModel(
      id: doc.id,
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
      category: doc['category'] ?? '',
      priority: doc['priority'] ?? '',
      isCompleted: doc['isCompleted'] ?? false, // Sertakan isCompleted

      members: (doc['members'] as List)
          .map((member) => UserModel.fromMap(member))
          .toList(), // List of member
      startDate:
          DateTime.parse(doc['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(doc['endDate'] ?? DateTime.now().toIso8601String()),
      createdAt:
          DateTime.parse(doc['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(doc['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
