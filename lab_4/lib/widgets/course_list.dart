import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/course.dart';

class CourseList extends StatelessWidget {
  final List<Course> courses;

  CourseList(this.courses);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: courses.map((course) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
          height: 100,
          child: Card(
            elevation: 5,
            child: Column(children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  course.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                DateFormat().format(course.date),
                style: TextStyle(color: Colors.black45),
              )
            ]),
          ),
        );
      }).toList(),
    );
  }
}
