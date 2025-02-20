/// Service class for handling API communications with the Enhanzer backend.
/// Handles authentication and data fetching operations.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../helpers/database_helper.dart';

class ApiService {
  /// Base URL for all API endpoints
  static const String apiUrl = "https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke";

  /// Authenticates user with the backend API
  /// 
  /// Takes [username] and [password] and returns true if login successful
  /// Also stores user data in local database if login succeeds
  Future<bool> loginUser(String username, String password) async {
    try {
      print('Attempting login with username: $username');
      
      // Construct request body according to API specification
      final requestBody = {
        "API_Body": [
          {"Unique_Id": "", "Pw": password}
        ],
        "Api_Action": "GetUserData",
        "Company_Code": username,
      };
      
      print('Sending request: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validate response and process user data
        if (data['Status_Code'] == 200 && data['Response_Body'] != null && data['Response_Body'].isNotEmpty) {
          final userData = data['Response_Body'][0];
          print('User data received: $userData');
          
          // Convert JSON to User object
          final user = User.fromJson(userData);
          print('User object created: ${user.displayName}');
          
          // Store in local database
          await DatabaseHelper.instance.insertUser(user);
          print('User saved to database');
          
          return true;
        } else {
          print('Login failed: Invalid response format or empty response body');
          print('Status Code: ${data['Status_Code']}');
          print('Message: ${data['Message']}');
          return false;
        }
      } else {
        print('Login failed: Server returned ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }
}
