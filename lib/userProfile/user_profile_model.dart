import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id;
  String? studentId;
  String fullName;
  String email;
  String? phoneNumber;
  String? gender;
  String? dateOfBirth;
  DateTime? enrollmentDate;
  String? password;
  bool isActive;
  bool isAdmin;
  String role;
  List<String> fcmTokens;


  UserProfile(
      {
        required this.id,
        this.studentId,
        required this.fullName,
        required this.email,
        this.phoneNumber,
        this.gender,
        this.dateOfBirth,
        this.enrollmentDate,
        this.password,
        this.isAdmin=false,
        this.isActive=true,
        this.role="student",
        this.fcmTokens=const[]
      });

  Map<String, dynamic> toMap() {
    if (this.email == 'ayesha@gmail.com') {
      return {
        'id':id,
        'fullName': fullName,
        'email': email,
        'isAdmin': isAdmin,
        'fcmTokens': fcmTokens,
        'role':role
    };}
    else{
    return {
      'id': id,
      'studentId': studentId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'enrollmentDate': enrollmentDate != null ? Timestamp.fromDate(enrollmentDate!) : null,
      'password': password,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'role' : role,
      'fcmTokens': fcmTokens,
      // Store the list in your database

    };}
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    if (map['email'] == 'ayesha@gmail.com') {
      return UserProfile(
          id: documentId,
          fullName: map['fullName'] ?? '',
          email: map['email'] ?? '',
          isAdmin: map['isAdmin'] ?? true,
          fcmTokens: List<String>.from(map['fcmTokens'] ?? []),
      );
    }else{
    return UserProfile(
      id: documentId,
      studentId: map['studentId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      enrollmentDate: map['enrollmentDate']?.toDate() ?? DateTime.now(),
      password: map['password'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      isActive: map['isActive'] ?? true,
      role: map['role'] ?? '',
      // We pass the document ID separately
      fcmTokens: List<String>.from(map['fcmTokens'] ?? []),


    );}
  }
}
