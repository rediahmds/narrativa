import 'package:geocoding/geocoding.dart';

class GeocodingFormat {
  static Future<String> getAddressFromLatLng({
    required double lat,
    required double lon,
  }) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lon,
      );
      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        final address = getAddressFromPlacemark(placemark);

        return address;
      } else {
        return "No address found";
      }
    } on NoResultFoundException catch (nf) {
      return "No result found: ${nf.toString()}";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  static String getAddressFromPlacemark(Placemark placemark) {
    return "${placemark.subLocality}, ${placemark.administrativeArea}, ${placemark.country}";
  }
}
