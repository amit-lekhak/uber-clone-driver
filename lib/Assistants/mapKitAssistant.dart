import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant {
  static double getMarkerRotation(sLat, sLng, dLat, dLng) {
    var rot =
        SphericalUtil.computeHeading(LatLng(sLat, sLng), LatLng(dLat, dLng));

    return rot;
  }


}
