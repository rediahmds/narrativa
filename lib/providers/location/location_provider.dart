import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:narrativa/static/static.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationProvider extends ChangeNotifier {
  final Location _location = Location();

  LocationState _locationState = LocationState();
  LocationState get locationState => _locationState;

  geocoding.Placemark? _selectedLocation;
  geocoding.Placemark? get selectedLocation => _selectedLocation;

  set selectedLocation(geocoding.Placemark? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> fetchLocation() async {
    _updateState(_locationState.copyWith(status: LocationStatus.fetching));

    try {
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final serviceEnabledResult = await _location.requestService();
        if (!serviceEnabledResult) {
          _updateState(
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
          _updateState(
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
      selectedLocation = placemarks.first;

      _updateState(
        _locationState.copyWith(
          status: LocationStatus.retrieved,
          locationData: locationData,
        ),
      );
    } catch (e) {
      _updateState(
        _locationState.copyWith(
          status: LocationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _updateState(LocationState newState) {
    _locationState = newState;
    notifyListeners();
  }
}
