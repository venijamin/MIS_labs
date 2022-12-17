import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/widgets/auth/utils.dart';
import 'package:lab_3/widgets/auth/user_auth_page.dart';
import 'package:lab_3/widgets/calendar.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/auth/sign_in.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/course.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MyHomePage();
              } else {
                return UserAuthPage();
              }
            }));
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Flutter App',
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final Map<DateTime, List<Course>> _mapUserCourses = {};

  void _addNewCourse(String title, DateTime date) {
    final newCourse = Course(title: title, date: date);
    final DateTime mapDate = DateTime(date.year, date.month, date.day);

    setState(() {
      List<Course> list = _mapUserCourses[mapDate] ?? [];
      if (!list.contains(newCourse)) {
        list.add(newCourse);
      }
      _mapUserCourses[mapDate] = list;
      print(_mapUserCourses.entries);
      print(list.last);
    });
  }

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
    return _mapUserCourses[mapDate] ?? [];
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
        ],
      ),
    );
  }
}
