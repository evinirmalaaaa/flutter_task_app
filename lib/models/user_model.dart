import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Fungsi untuk konversi dari DocumentSnapshot ke UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc['email'],
      password: doc['password'],
      name: doc['name'],
      createdAt:
          DateTime.parse(doc['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(doc['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  factory UserModel.fromMap(Map map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Fungsi untuk konversi dari UserModel ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
