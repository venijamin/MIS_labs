import 'package:lab_3/main.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    LocationData ld = await location.getLocation();
    print(ld);
    print("###");
    String gUrl = 'https://www.google.com/maps?saddr=${ld.latitude},${ld.longitude}&daddr=$latitude,$longitude';
      await launchUrlString(gUrl);

  }
}