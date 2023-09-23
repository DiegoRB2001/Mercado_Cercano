import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.geolocation, required this.market});
  final GeoPoint geolocation;
  final String market;

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(market),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(geolocation.latitude, geolocation.longitude),
                zoom: 19),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            markers: {
              Marker(
                markerId: const MarkerId('1'),
                position: LatLng(geolocation.latitude, geolocation.longitude),
              )
            },
          ),
        ),
      ),
    );
  }
}
