import 'package:flutter/material.dart';

class User {
  final String userCode;
  final String displayName;
  final String email;
  final String employeeCode;
  final String companyCode;

  User({
    required this.userCode,
    required this.displayName,
    required this.email,
    required this.employeeCode,
    required this.companyCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // For API response
    if (json.containsKey('User_Code')) {
      return User(
        userCode: json['User_Code'] ?? '',
        displayName: json['User_Display_Name'] ?? '',
        email: json['Email'] ?? '',
        employeeCode: json['User_Employee_Code'] ?? '',
        companyCode: json['Company_Code'] ?? '',
      );
    }
    // For database response
    return User(
      userCode: json['userCode'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      companyCode: json['companyCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userCode': userCode,
      'displayName': displayName,
      'email': email,
      'employeeCode': employeeCode,
      'companyCode': companyCode,
    };
  }

  @override
  String toString() {
    return 'User(userCode: $userCode, displayName: $displayName, email: $email, employeeCode: $employeeCode, companyCode: $companyCode)';
  }
}
