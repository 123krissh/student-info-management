import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'add_student_page.dart';
import 'students_page.dart';
import 'view_opportunities_page.dart';
import 'add_opportunity_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/students': (context) => const StudentsPage(),
        '/add-student': (context) => const AddStudentPage(),
        '/view-opportunities': (context) => OpportunityPage(),
        '/add-opportunity': (context) => AddOpportunityPage(),
      },
    );
  }
}
