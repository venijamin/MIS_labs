import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/widgets/utils.dart';
import 'package:lab_3/widgets/auth/user_auth_page.dart';
import 'package:lab_3/widgets/calendar.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/auth/sign_in.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/course.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

Map<DateTime, List<Course>> _mapUserCourses = {};

Map<DateTime, List<Course>> convertMap(Map<String, dynamic> map) {
  final Map<DateTime, List<Course>> courseMap = {};
  for (String key in map.keys) {
    print(key +
        '################################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@22');
    DateTime mapDate = DateTime.parse(key.toString());
    List<Course> list = [];
    for (String key2 in map[key].keys) {
      Course course = Course(title: key2, date: DateTime.parse(map[key][key2]));
      list.add(course);
    }

    courseMap[mapDate] = list;
  }
  return courseMap;
}

// Checks if the document for saving the courses exists
Future<bool> checkExist(String uid) async {
  bool exist = false;
  try {
    await events.doc(uid).get().then((doc) {
      exist = doc.exists;
    });
    return exist;
  } catch (e) {
    // If any error
    return false;
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Get the document if it exists,
                // else create a new document
                String? uid = FirebaseAuth.instance.currentUser?.uid;
                print('#######################USER####################: $uid');
                events.doc(uid).get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  print(
                      'DATA: ${data.entries} ###################################################3');
                  _mapUserCourses = convertMap(data['events']);
                }, onError: (e) => events.doc(uid).set({}));

                uid = FirebaseAuth.instance.currentUser?.uid;

                checkExist(uid ?? '').then((value) {
                  value
                      ? null
                      : events.doc(uid).set(
                          {'events': {}},
                        );
                });

                return MyHomePage();
              } else {
                return UserAuthPage();
              }
            }));
  }
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

CollectionReference events = FirebaseFirestore.instance.collection('events');

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  void _addNewCourse(String title, DateTime date) {
    final newCourse = Course(title: title, date: date);
    final DateTime mapDate = DateTime(date.year, date.month, date.day);

    setState(() {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      List<Course> list = _mapUserCourses[mapDate] ?? [];
      if (!list.contains(newCourse)) {
        list.add(newCourse);
      }
      _mapUserCourses[mapDate] = list;

      // ?? Convert _mapUserCourses to a map <String, Map>, so it can be written to firestore
      Map<String, Map> tempMap = {};
      for (DateTime key in _mapUserCourses.keys) {
        Map<String, String> map = toMap(_mapUserCourses[key] ?? []);
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
    return _mapUserCourses[mapDate] ?? [];
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
