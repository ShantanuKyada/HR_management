import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TeacherDashBoard extends StatefulWidget {
  @override
  _TeacherDashBoardState createState() => _TeacherDashBoardState();
}

class _TeacherDashBoardState extends State<TeacherDashBoard> {
  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('http://192.168.174.45/get_employees.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Employee.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> checkIn(int employeeId) async {
    final response = await http.post(
      Uri.parse('http://192.168.174.45/check_in.php'),
      body: {'employee_id': employeeId.toString()},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse == "Success") {
        Fluttertoast.showToast(msg: 'Check-in successful');
      } else {
        Fluttertoast.showToast(msg: 'Check-in failed');
      }
    }
  }

  Future<void> checkOut(int employeeId) async {
    final response = await http.post(
      Uri.parse('http://192.168.174.45/check_out.php'),
      body: {'employee_id': employeeId.toString()},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse == "Success") {
        Fluttertoast.showToast(msg: 'Check-out successful');
      } else {
        Fluttertoast.showToast(msg: 'Check-out failed');
      }
    }
  }

  Future<void> submitTask(int employeeId, String task) async {
    final response = await http.post(
      Uri.parse('http://192.168.174.45/submit_task.php'),
      body: {
        'employee_id': employeeId.toString(),
        'task': task,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse == "Success") {
        Fluttertoast.showToast(msg: 'Task submitted successfully');
      } else {
        Fluttertoast.showToast(msg: 'Task submission failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Dashboard'),
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
                return EmployeeCard(
                  employee: snapshot.data![index],
                  checkIn: () => checkIn(snapshot.data![index].id),
                  checkOut: () => checkOut(snapshot.data![index].id),
                  submitTask: (task) => submitTask(snapshot.data![index].id, task),
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
  final int id;
  final String name;
  final String checkIn;
  final String checkOut;
  final String task;

  Employee({required this.id, required this.name, required this.checkIn, required this.checkOut, required this.task});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['Name'],
      checkIn: json['Check_in'],
      checkOut: json['Check_out'],
      task: json['Task'],
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final Employee employee;
  final VoidCallback checkIn;
  final VoidCallback checkOut;
  final Function(String) submitTask;

  EmployeeCard({required this.employee, required this.checkIn, required this.checkOut, required this.submitTask});

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.employee.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in: ${widget.employee.checkIn}'),
            Text('Check-out: ${widget.employee.checkOut}'),
            Text('Task: ${widget.employee.task}'),
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: widget.checkIn,
                  child: Text('Check In'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: widget.checkOut,
                  child: Text('Check Out'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.submitTask(taskController.text);
                    taskController.clear();
                  },
                  child: Text('Submit Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}