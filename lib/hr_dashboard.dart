import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HRDashboard extends StatefulWidget {
  @override
  _HRDashboardState createState() => _HRDashboardState();
}

class _HRDashboardState extends State<HRDashboard> {
  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('http://192.168.174.45/hrdashboard.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Employee.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Management Dashboard'),
      ),
      body: FutureBuilder<List<Employee>>(
        future: fetchEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No employees found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payroll: ${snapshot.data?[index].payroll}'),
                      Text('Check In: ${snapshot.data?[index].checkIn}'),
                      Text('Check Out: ${snapshot.data?[index].checkOut}'),
                      Text('Task: ${snapshot.data?[index].task}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Employee {
  final String name;
  final String password;
  final String payroll;
  final String checkIn;
  final String checkOut;
  final String task;

  Employee({required this.name, required this.password, required this.payroll, required this.checkIn, required this.checkOut, required this.task});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      password: json['password'],
      payroll: json['payroll'],
      checkIn: json['Check_in'],
      checkOut: json['Check_out'],
      task: json['Task'],
    );
  }
}
