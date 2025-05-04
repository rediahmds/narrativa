import 'dart:io';

import 'package:flutter/material.dart';
import 'package:narrativa/static/static.dart';
import 'package:narrativa/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:narrativa/providers/providers.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({
    super.key,
    required this.onLogout,
    required this.onUploaded,
    required this.onAddLocation,
  });

  final Function onLogout;
  final Function onUploaded;
  final Function onAddLocation;

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Story"), centerTitle: true),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        width: MediaQuery.of(context).size.width,
        child: FilledButton.icon(
          icon: const Icon(Icons.send_rounded),
          label: const Text("Upload"),
          onPressed: () async {
            final sessionProvider = context.read<SessionProvider>();
            final token = sessionProvider.state.loginResult?.token;
            if (token == null) {
              widget.onLogout();
              return;
            }

            final addStoryProvider = context.read<AddStoryProvider>();
            await addStoryProvider.uploadStory(
              token: token,
              description: addStoryProvider.descriptionController.text,
            );

            if (addStoryProvider.state.status == AddStoryStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(addStoryProvider.state.errorMessage!)),
              );
            }

            if (addStoryProvider.state.status == AddStoryStatus.uploadSuccess) {
              final storiesProvider = context.read<StoriesProvider>();
              storiesProvider.clearStories();

              addStoryProvider.descriptionController.clear();
              addStoryProvider.clearImage();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Story uploaded successfully")),
              );

              debugPrint("Story page value: ${storiesProvider.page}");

              widget.onUploaded();
            }
          },
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AddStoryProvider>(
            builder: (_, addStoryProvider, _) {
              final locationProviderWatch = context.watch<LocationProvider>();
              final selectedLocation = locationProviderWatch.selectedLocation;
              debugPrint(
                "Selected location: ${selectedLocation?.toJson().toString()}",
              );

              String address;
              if (locationProviderWatch.locationState.status ==
                  LocationStatus.fetching) {
                address = "Fetching location...";
              } else if (locationProviderWatch.locationState.status ==
                  LocationStatus.error) {
                address = "Error fetching location";
              } else if (selectedLocation != null) {
                address =
                    "${selectedLocation.street}, ${selectedLocation.subLocality}, ${selectedLocation.locality}, ${selectedLocation.subAdministrativeArea}";
              } else {
                address = "No location selected";
              }
              // final address =
              //     selectedLocation != null
              //         ? "${selectedLocation.street}, ${selectedLocation.subLocality}, ${selectedLocation.locality}, ${selectedLocation.subAdministrativeArea}"
              //         : "No location selected";
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  spacing: 18,
                  children: [
                    if (addStoryProvider.state.image != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(addStoryProvider.state.image!.path),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(Icons.image, size: 100),
                            Text("No image selected"),
                          ],
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            addStoryProvider.openGalleryView();
                          },
                          child: const Text("Select from Gallery"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addStoryProvider.openCameraView();
                          },
                          child: const Text("Take a Photo"),
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text("Location"),
                      subtitle: Text(address),
                      isThreeLine: true,
                      trailing: const Icon(Icons.location_on_rounded),
                      onTap: () {
                        widget.onAddLocation();
                      },
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: NarrativaTextField(
                        controller: addStoryProvider.descriptionController,
                        labelText: "Description",
                        textInputType: TextInputType.multiline,
                        expands: true,
                        hintText: "Write a description",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (description) {
                          if (description == null || description.isEmpty) {
                            return "Description cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (addStoryProvider.state.status ==
                        AddStoryStatus.uploading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
