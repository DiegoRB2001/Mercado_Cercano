import 'package:cloud_firestore/cloud_firestore.dart';

class Market {
  final String name;
  final String address;
  final String schedule;
  final String phone;
  final Map<String, dynamic> location;
  final GeoPoint geolocation;
  final String cover;
  final String description;
  final List products;
  final List images;

  const Market(
      {required this.name,
      required this.address,
      required this.schedule,
      required this.phone,
      required this.location,
      required this.geolocation,
      required this.cover,
      required this.images,
      required this.description,
      required this.products});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
        name: json['name'],
        address: json['address'],
        schedule: json['schedule'],
        phone: json['phone'],
        location: json['location'],
        geolocation: json['geolocation'],
        cover: json['cover'],
        images: json['images'],
        description: json['description'],
        products: json['products']);
  }
}
