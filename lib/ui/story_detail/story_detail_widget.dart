import 'package:flutter/material.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/utils/utils.dart';

class StoryDetail extends StatelessWidget {
  const StoryDetail({
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
