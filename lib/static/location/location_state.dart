import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:narrativa/static/static.dart';

class LocationState {
  const LocationState({
    this.status = LocationStatus.initial,
    this.locationData,
    this.errorMessage,
    this.placemark,
  });

  final LocationStatus status;
  final LocationData? locationData;
  final String? errorMessage;
  final Placemark? placemark;

  LocationState copyWith({
    LocationStatus? status,
    LocationData? locationData,
    String? errorMessage,
    Placemark? placemark,
  }) {
    return LocationState(
      status: status ?? this.status,
      locationData: locationData ?? this.locationData,
      errorMessage: errorMessage ?? this.errorMessage,
      placemark: placemark ?? this.placemark,
    );
  }

  @override
  String toString() {
    return "LocationState(status: $status, locationData: $locationData, errorMessage: $errorMessage), placemark: $placemark)";
  }
}
