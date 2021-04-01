import 'package:vector_math/vector_math.dart' as Vec;
import 'dart:math' as Math;

class Haversine {
  final int _earthRadius = 6371;

    double distance(
      double startLat, double startLong,
      double endLat, double endLong) {
        double dLat  = Vec.degrees2Radians * (endLat - startLat);
        double dLong = Vec.degrees2Radians * (endLong - startLong);

        startLat = Vec.degrees2Radians * startLat;
        endLat   = Vec.degrees2Radians * endLat;

        double a = _haversin(dLat) + Math.cos(startLat) * Math.cos(endLat) * _haversin(dLong);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return _earthRadius * c;
    }

    double _haversin(double val) {
        return Math.pow(Math.sin(val / 2), 2);
    }
}