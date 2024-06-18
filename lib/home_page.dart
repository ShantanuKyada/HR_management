import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HR Task Tracker',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Employee Login',
                  style:
                  TextStyle(fontSize: 15.00, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/teacherlogin');
                },
                child: Text(
                  'HR Login',
                  style:
                  TextStyle(fontSize: 15.00, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
