import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:lab_3/widgets/user_course.dart';

import 'models/course.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

final titleController = TextEditingController();

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: ListView(children: [
        UserCourse(),
      ]),
    );
  }
}
