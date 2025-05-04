import 'package:location/location.dart';
import 'package:narrativa/static/static.dart';

class LocationState {
  const LocationState({
    this.status = LocationStatus.initial,
    this.locationData,
    this.errorMessage,
  });

  final LocationStatus status;
  final LocationData? locationData;
  final String? errorMessage;

  LocationState copyWith({
    LocationStatus? status,
    LocationData? locationData,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      locationData: locationData ?? this.locationData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return "LocationState(status: $status, locationData: $locationData, errorMessage: $errorMessage)";
  }
}
