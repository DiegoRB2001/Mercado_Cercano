import 'package:geolocator/geolocator.dart';
import 'package:mercado_cercano/functions/geolocator.dart';
import 'package:mercado_cercano/models/market.dart';

void sortMarkets(List<Market> markets, Position position) {
  markets.sort((a, b) => calculateDistanceBetweenCoords(position.latitude,
          position.longitude, a.geolocation.latitude, a.geolocation.longitude)
      .compareTo(calculateDistanceBetweenCoords(
          position.latitude,
          position.longitude,
          b.geolocation.latitude,
          b.geolocation.longitude)));
}
