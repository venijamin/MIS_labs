import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../models/course.dart';
import '../widgets/notif.dart';
import '../widgets/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Notif notif = Notif();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    notif.initialiseNotifications();

    uid = FirebaseAuth.instance.currentUser?.uid;
    events.doc(uid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      mapUserCourses = Utils.convertMap(data['events']);
    }, onError: (e) => events.doc(uid).set({}));
  }

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  final titleController = TextEditingController();

  void _addNewCourse(String title, DateTime date, LatLng? location) {
    final newCourse = Course(title, date, location);
    final DateTime mapDate = DateTime(date.year, date.month, date.day);

    setState(() {
      List<Course> list = mapUserCourses[mapDate] ?? [];
      if (!list.contains(newCourse)) {
        list.add(newCourse);
      }
      mapUserCourses[mapDate] = list;
      notif.sendScheduled('Course in 4 hours', title, date);

      // ?? Convert _mapUserCourses to a map <String, Map>, so it can be written to firestore
      Map<String, Map> tempMap = {};
      for (DateTime key in mapUserCourses.keys) {
        Map<String, String> map = toMap(mapUserCourses[key] ?? []);
        String day = key.toString();

        tempMap[day] = map;
      }
      // If the document for the given user exists just add onto it,
      // else create a new document
      checkExist(uid ?? '').then((value) {
        value
            ? events.doc(uid).update(
                {'events': tempMap},
              )
            : events.doc(uid).set(
                {'events': tempMap},
              );
      });
    });
  }

  Map<String, String> toMap(List<Course> list) {
    Map<String, String> map = {};
    for (Course course in list) {
      map[course.title] = course.date.toString();
    }

    return map;
  }

// Brings up the course creation sheet
  void _startAddNewCourse(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewCourse(_addNewCourse);
        });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Course> _getEventsForDay(DateTime day) {
    DateTime mapDate = DateTime(day.year, day.month, day.day);
    return mapUserCourses[mapDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${FirebaseAuth.instance.currentUser?.email}'),
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
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2100, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: ((selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }),
              eventLoader: ((day) {
                return _getEventsForDay(day);
              }),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
          ),
          CourseList(_getEventsForDay(_focusedDay)),
          Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.door_back_door_outlined),
              label: Text(
                'Sign out',
                style: TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
