import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/widgets/calendar.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/course.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final List<Course> _userCourses = [];

  void _addNewCourse(String title, DateTime date) {
    final newCourse = Course(title: title, date: date);

    setState(() {
      _userCourses.add(newCourse);
    });
  }

  void _startAddNewCourse(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewCourse(_addNewCourse);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        actions: [
          IconButton(
            onPressed: () => _startAddNewCourse(context),
            icon: Icon(Icons.add_box_outlined),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          Calendar(),
          CourseList(_userCourses),
        ],
      ),
    );
  }
}
