import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:narrativa/static/static.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationProvider extends ChangeNotifier {
  final Location _location = Location();

  LocationState _locationState = LocationState();
  LocationState get locationState => _locationState;

  Future<void> fetchLocation() async {
    updateState(_locationState.copyWith(status: LocationStatus.fetching));

    try {
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final serviceEnabledResult = await _location.requestService();
        if (!serviceEnabledResult) {
          updateState(
            _locationState.copyWith(
              status: LocationStatus.error,
              errorMessage: "Location service is disabled",
            ),
          );
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          updateState(
            _locationState.copyWith(
              status: LocationStatus.error,
              errorMessage: "Location permission denied",
            ),
          );
          return;
        }
      }

      final locationData = await _location.getLocation();
      final placemarks = await geocoding.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      final placemark = placemarks.first;

      updateState(
        _locationState.copyWith(
          status: LocationStatus.retrieved,
          locationData: locationData,
          placemark: placemark,
        ),
      );
    } catch (e) {
      updateState(
        _locationState.copyWith(
          status: LocationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setToCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      final placemarks = await geocoding.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      final placemark = placemarks.first;

      updateState(
        _locationState.copyWith(
          locationData: locationData,
          placemark: placemark,
        ),
      );
    } catch (e) {
      updateState(
        _locationState.copyWith(
          status: LocationStatus.error,
          errorMessage: e.toString(),
        ),
      );
      rethrow;
    }
  }

  void updateState(LocationState newState) {
    _locationState = newState;
    notifyListeners();
  }
}
