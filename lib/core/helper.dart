import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double distanceBetween(LatLng p1, LatLng p2) {
  const earthRadius = 6371000; // meters

  final lat1 = _toRadians(p1.latitude);
  final lat2 = _toRadians(p2.latitude);
  final deltaLat = _toRadians(p2.latitude - p1.latitude);
  final deltaLng = _toRadians(p2.longitude - p1.longitude);

  final a =
      sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _toRadians(double degree) => degree * pi / 180;
