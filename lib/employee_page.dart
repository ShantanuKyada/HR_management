import 'dart:convert';
import 'package:attendance_system/Employee_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeLoginPage extends StatefulWidget {
  @override
  _EmployeeLoginPageState createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://192.168.174.45/employeelogin.php'),
      body: {
        'name': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result == "Success") {
        // Navigate to the next screen or perform any action upon successful login
        print("Login Successful");
      } else {
        // Display an error message or perform any action upon failed login
        print("Login Failed");
      }
    } else {
      // Handle server errors
      print("Server Error: ${response.statusCode}");
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                _login();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Employee Login',
    home: EmployeeLoginPage(),
  ));
}