import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/static/static.dart';
import 'package:narrativa/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:narrativa/ui/ui.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.storyId,
    required this.onLogout,
  });

  final String storyId;
  final Function onLogout;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    final sessionState = context.read<SessionProvider>().state;
    final token = sessionState.loginResult?.token;

    if (token == null) {
      widget.onLogout();
      return;
    }

    Future.microtask(() {
      context.read<DetailProvider>().fetchDetail(
        token: token,
        id: widget.storyId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Details')),
      body: Consumer<DetailProvider>(
        builder: (_, detailProvider, _) {
          switch (detailProvider.state.status) {
            case DetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case DetailStatus.loaded:
              final story = detailProvider.state.story!;

              if (story.lat != null && story.lon != null) {
                final coord = LatLng(story.lat!, story.lon!);
                return Stack(
                  children: [
                    GoogleMap(
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(coord.latitude, coord.longitude),
                        zoom: 12,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("story_location"),
                          position: LatLng(story.lat!, story.lon!),
                          onTap: () async {
                            _mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(coord, 20),
                            );

                            final address =
                                await GeocodingFormat.getAddressFromLatLng(
                                  lat: coord.latitude,
                                  lon: coord.longitude,
                                );

                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width - 36,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Story Location",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        address,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      },
                    ),
                    Positioned(
                      bottom: 18,
                      left: 0,
                      right: 0,
                      child: Card.filled(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StoryDetail(story: story, showDescription: false),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                bottom: 8,
                              ),
                              child: FilledButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) {
                                      return SingleChildScrollView(
                                        child: StoryDetail(story: story),
                                      );
                                    },
                                  );
                                },
                                child: const Text("View details"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return StoryDetail(story: story);

            case DetailStatus.error:
            default:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    const SizedBox(height: 8),
                    Text(
                      detailProvider.state.errorMessage ?? 'An error occurred.',
                      textAlign: TextAlign.center,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.go(AppPaths.stories.path);
                      },
                      label: const Text("Go Back"),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
