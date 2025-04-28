import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String gender;
  final DateTime? createdAt;
  final String? address; // Example app-specific field
  final String? phoneNumber; // Example app-specific field

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.gender,
    this.createdAt,
    this.address,
    this.phoneNumber,
  });

  // Factory constructor to create UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      address: data['address'],
      phoneNumber: data['phoneNumber'],
    );
  }

  // Convert UserModel to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      if (address != null) 'address': address,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}
