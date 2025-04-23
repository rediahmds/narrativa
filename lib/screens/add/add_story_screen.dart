import 'dart:io';

import 'package:flutter/material.dart';
import 'package:narrativa/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:narrativa/providers/providers.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Story"), centerTitle: true),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        width: MediaQuery.of(context).size.width,
        child: FilledButton.icon(
          icon: const Icon(Icons.send_rounded),
          onPressed: () {},
          label: const Text("Submit"),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AddStoryProvider>(
            builder: (_, addStoryProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  spacing: 18,
                  children: [
                    if (addStoryProvider.imagePath != null) ...[
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
                            File(addStoryProvider.imagePath!),
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
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: NarrativaTextField(
                        controller: _descriptionController,
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
                    const SizedBox(height: 18),
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
