import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:narrativa/models/stories/story.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/static/static.dart';
import 'package:narrativa/utils/utils.dart';
import 'package:provider/provider.dart';

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
                        //  if error, try to define a provider
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("story_location"),
                          position: LatLng(story.lat!, story.lon!),
                          onTap: () {
                            _mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(coord, 20),
                            );

                            final placemarks = await geocoding
                                .placemarkFromCoordinates(
                                  coord.latitude,
                                  coord.longitude,
                                );

                            final placemark = placemarks.first;
                            final administrativeArea =
                                placemark.administrativeArea ?? "Unknown area";
                            final street = placemark.street ?? "Unknown street";
                            final country =
                                placemark.country ?? "Unknown country";
                            final postalCode =
                                placemark.postalCode ?? "Unknown postal code";
                            final city = placemark.locality ?? "Unknown city";

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
                                        street,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "$city, $administrativeArea, $country, $postalCode",
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
                            StoryContent(story: story, showDescription: false),
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
                                        child: StoryContent(story: story),
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

              return StoryContent(story: story);

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

class StoryContent extends StatelessWidget {
  const StoryContent({
    super.key,
    required this.story,
    this.showDescription = true,
  });

  final Story story;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading-bean-eater.gif",
                placeholderScale: 0.1,
                placeholderFit: BoxFit.scaleDown,
                image: story.photoUrl,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      const Icon(Icons.broken_image_rounded, size: 48),
                      const Text("Couldn't load image"),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(story.name, style: Theme.of(context).textTheme.titleLarge),
          Text(
            JiffyFormat.relativeTime(story.createdAt.toIso8601String()),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          if (showDescription)
            Text(
              story.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
