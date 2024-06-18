import 'package:flutter/scheduler.dart';

import 'hr_login.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'employee_page.dart';
import 'hr_dashboard.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrintBeginFrameBanner: false;
    return MaterialApp(
      title: 'HR System',
      theme: ThemeData(
        colorScheme: ColorScheme.dark().copyWith(primary: Colors.blue),
      ),
      home: HomePage(),
      routes: {
        '/login': (context) => EmployeeLoginPage(),
        '/teacherlogin': (context) => LoginPage2(),
        '/teacherDashboard': (context) => HRDashboard(),
      },
    );
  }
}