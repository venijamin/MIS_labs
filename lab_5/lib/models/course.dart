import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Course {
  final String title;
  final DateTime date;
  final LatLng? location;

  Course(this.title, this.date, [this.location = null]);
}
