import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/static/static.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _controller;
  late final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Picker')),
      body: Consumer<LocationProvider>(
        builder: (_, locationProvider, _) {
          switch (locationProvider.locationState.status) {
            case LocationStatus.initial:
              return const Center(child: Text('Location not fetched yet'));

            case LocationStatus.fetching:
              return const Center(child: CircularProgressIndicator());

            case LocationStatus.retrieved:
              final locationData = locationProvider.locationState.locationData!;
              final placemark = locationProvider.locationState.placemark!;
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        locationData.latitude!,
                        locationData.longitude!,
                      ),
                      zoom: 14,
                    ),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      _controller = controller;

                      setState(() {
                        _markers.add(
                          Marker(
                            markerId: const MarkerId('selected-location'),
                            position: LatLng(
                              locationData.latitude!,
                              locationData.longitude!,
                            ),
                          ),
                        );
                      });
                    },
                    onTap: (LatLng coord) async {
                      final newLocationData = LocationData.fromMap({
                        "latitude": coord.latitude,
                        "longitude": coord.longitude,
                      });
                      final placemarks = await geocoding
                          .placemarkFromCoordinates(
                            coord.latitude,
                            coord.longitude,
                          );
                      final placemark = placemarks.first;

                      locationProvider.updateState(
                        locationProvider.locationState.copyWith(
                          locationData: newLocationData,
                          placemark: placemark,
                        ),
                      );

                      setState(() {
                        _markers
                          ..clear()
                          ..add(
                            Marker(
                              markerId: const MarkerId('selected-location'),
                              position: LatLng(coord.latitude, coord.longitude),
                            ),
                          );
                        _controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(coord.latitude, coord.longitude),
                          ),
                        );
                      });
                    },
                    markers: _markers,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: FloatingActionButton.small(
                      tooltip: "My Location",
                      child: const Icon(Icons.my_location),
                      onPressed: () async {
                        await locationProvider.setToCurrentLocation();
                        final currentLocationData =
                            locationProvider.locationState.locationData!;

                        _controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              currentLocationData.latitude!,
                              currentLocationData.longitude!,
                            ),
                          ),
                        );

                        setState(() {
                          _markers
                            ..clear()
                            ..add(
                              Marker(
                                markerId: const MarkerId('selected-location'),
                                position: LatLng(
                                  currentLocationData.latitude!,
                                  currentLocationData.longitude!,
                                ),
                              ),
                            );
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Card.filled(
                            margin: const EdgeInsets.all(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 8,
                                children: [
                                  const Text(
                                    "Selected Location",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );

            case LocationStatus.error:
              return Center(
                child: Text(locationProvider.locationState.errorMessage!),
              );
          }
        },
      ),
    );
  }
}
