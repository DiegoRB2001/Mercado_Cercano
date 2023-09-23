import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Map<String, String>> getLocationFromCoordinates(
        Position position) async =>
    await placemarkFromCoordinates(position.latitude, position.longitude).then(
        (placemarks) => {
              'state': placemarks[0].administrativeArea!,
              'city': placemarks[0].locality!
            });
