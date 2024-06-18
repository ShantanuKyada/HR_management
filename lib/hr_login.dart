import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'hr_dashboard.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPageState2 createState() => _LoginPageState2();
}

class _LoginPageState2 extends State<LoginPage2> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> login() async {
    var url = Uri.parse("http://192.168.174.45/hrlogin.php");

    try {
      var response = await http.post(url, body: {
        "username": user.text,
        "password": pass.text,
      });

      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HRDashboard()),
        );
        } else {
        Fluttertoast.showToast(
          msg: 'Username and password invalid',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'An error occurred',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: user,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: pass,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}