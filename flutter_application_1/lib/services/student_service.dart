import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart'; // Import your constants file

// Fetch students
Future<List<dynamic>> getStudents() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load students');
  }
}

// Add student
Future<void> addStudent(Map<String, dynamic> studentData) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(studentData),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to add student');
  }
}
