import 'package:flutter/material.dart';

import '../main.dart';
import '../models/course.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackbar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.blueGrey,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  static Map<DateTime, List<Course>> convertMap(Map<String, dynamic> map) {
    final Map<DateTime, List<Course>> courseMap = {};
    for (String key in map.keys) {
      DateTime mapDate = DateTime.parse(key.toString());
      List<Course> list = [];
      for (String key2 in map[key].keys) {
        Course course = Course(key2, DateTime.parse(map[key][key2]));
        list.add(course);
      }

      courseMap[mapDate] = list;
    }
    return courseMap;
  }
}
