import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/new_course.dart';

import '../models/course.dart';

class UserCourse extends StatefulWidget {
  const UserCourse({super.key});

  @override
  State<UserCourse> createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {
  final List<Course> _userCourses = [];

  void _addNewCourse(String title, DateTime date) {
    final newCourse = Course(title: title, date: date);

    setState(() {
      _userCourses.add(newCourse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewCourse(_addNewCourse),
        CourseList(_userCourses),
      ],
    );
  }
}
