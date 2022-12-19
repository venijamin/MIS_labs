import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/screens/home.dart';
import 'package:lab_3/widgets/notif.dart';
import 'package:lab_3/widgets/notif.dart';
import 'package:lab_3/widgets/utils.dart';
import 'package:lab_3/widgets/auth/user_auth_page.dart';
import 'package:lab_3/widgets/calendar.dart';
import 'package:lab_3/widgets/course_list.dart';
import 'package:lab_3/widgets/auth/sign_in.dart';
import 'package:lab_3/widgets/new_course.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'models/course.dart';
import 'screens/login.dart';

CollectionReference events = FirebaseFirestore.instance.collection('events');
Map<DateTime, List<Course>> mapUserCourses = {};

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
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
