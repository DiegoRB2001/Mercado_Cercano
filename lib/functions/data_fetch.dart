import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mercado_cercano/functions/custom_dialog.dart';
import 'package:mercado_cercano/functions/geocoding.dart';
import 'package:mercado_cercano/functions/geolocator.dart';
import 'package:mercado_cercano/models/market.dart';

Future<List<Market>> getMarkets(Map<String, dynamic> location) =>
    FirebaseFirestore.instance
        .collection('markets')
        .where("location", isEqualTo: location)
        .limit(10)
        .get()
        .then(((snapshot) =>
            snapshot.docs.map((doc) => Market.fromJson(doc.data())).toList()));

Future<List<Market>> filterMarkets(
        Map<String, dynamic> location, List<String> f) =>
    FirebaseFirestore.instance
        .collection('markets')
        .where("location", isEqualTo: location)
        .where(
          "products",
          arrayContainsAny: f,
        )
        .limit(10)
        .get()
        .then(((snapshot) =>
            snapshot.docs.map((doc) => Market.fromJson(doc.data())).toList()));

Future<Market> getMarket(String id) => FirebaseFirestore.instance
    .collection('markets')
    .where("id", isEqualTo: id)
    .get()
    .then((snapshots) => snapshots.docs
        .map((snapshot) => Market.fromJson(snapshot.data()))
        .first);

Future<String> getURL(String imageName) async {
  return await FirebaseStorage.instance
      .ref()
      .child("images/$imageName")
      .getDownloadURL();
}

Future<Map<String, dynamic>> getData(
    BuildContext context, List<String> filter) async {
  try {
    Position position = await determinePosition();
    Map<String, dynamic> location = await getLocationFromCoordinates(position);
    List<Market> markets = filter.isEmpty
        ? await getMarkets(location)
        : await filterMarkets(location, filter);

    return {'position': position, 'location': location, 'markets': markets};
  } catch (e) {
    if (context.mounted) customDialog(context);
    return Future.error(e.toString());
  }
}

Future<LocationPermission> checkLocationPermission() {
  return Geolocator.checkPermission();
}
