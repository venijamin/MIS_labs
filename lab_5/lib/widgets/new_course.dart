import 'dart:math';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/widgets/utils.dart';

class NewCourse extends StatefulWidget {
  final Function addNewCourse;
  NewCourse(this.addNewCourse);

  @override
  State<NewCourse> createState() => _NewCourseState();
}

class _NewCourseState extends State<NewCourse> {
  final titleController = TextEditingController();
  DateTime date = DateTime(0);

  void _presentDatePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((datePicked) => {
          if (datePicked != null) {date = datePicked}
        });

    await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: 0,
          minute: 0,
        )).then((timePicked) => {
          if (timePicked != null)
            {
              date = DateTime(date.year, date.month, date.day, timePicked.hour,
                  timePicked.minute)
            }
        });
    setState(() {
      if (date != DateTime(0)) {
        textDate = date.toString();
      } else {
        textDate = 'Select a date:';
      }
    });
  }

  String textDate = 'Select a date:';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(textDate),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Material(
                      elevation: 5,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                      child: IconButton(
                        onPressed: () {
                          _presentDatePicker();
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (!date.isBefore(DateTime.now()) &&
                      !titleController.text.isEmpty) {
                    widget.addNewCourse(titleController.text, date);
                    titleController.clear();
                    textDate = 'Select a date:';
                    date = DateTime(0);
                    Navigator.pop(context);
                    Utils.showSnackBar('Event created!');
                  }
                },
                child: Text('Ok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
