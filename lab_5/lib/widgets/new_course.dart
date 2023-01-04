import 'dart:math';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:intl/intl.dart';
import 'package:lab_3/main.dart';
import 'package:lab_3/widgets/utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class NewCourse extends StatefulWidget {
  final Function addNewCourse;
  NewCourse(this.addNewCourse);

  @override
  State<NewCourse> createState() => _NewCourseState();
}

class _NewCourseState extends State<NewCourse> {
  final titleController = TextEditingController();
  DateTime date = DateTime(0);

  late LocationData ld;
  void _presentLocationPicker() async {
    ld = await location.getLocation();

  }

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
    LatLng courseLocation = LatLng(0, 0);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              Container(
                height: 220,
                width: 320,
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return FlutterMap(
                      options: MapOptions(
                          // TODO Change center to user location


                          center: LatLng(41.9981, 21.4254),
                          zoom: 4,
                          onLongPress: ((tapPosition, point) {
                            setState(() {
                              courseLocation = point;
                              print(courseLocation);
                            });
                          })),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://api.maptiler.com/maps/basic-v2/256/{z}/{x}/{y}.png?key=VDu2b2FBb9sk00jAHiHy",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            // TODO Change point to user location
                            Marker(
                                point: courseLocation,
                                builder: (context) => Icon(Icons.location_pin))
                          ],
                        )
                      ],
                    );
                  },
                ),
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!date.isBefore(DateTime.now()) &&
                          !titleController.text.isEmpty) {
                        widget.addNewCourse(titleController.text, date, courseLocation);
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
            ],
          ),
        ),
      ),
    );
  }
}
