import 'package:flutter/material.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/utils/utils.dart';

class StoryCardWidget extends StatelessWidget {
  const StoryCardWidget({super.key, required this.story, required this.onTap});

  final Story story;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card.outlined(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/loading-bean-eater.gif",
                    placeholderScale: .1,
                    placeholderFit: BoxFit.scaleDown,
                    image: story.photoUrl,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            const Icon(Icons.broken_image_rounded, size: 48),
                            const Text("Couldn't load image"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      story.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      story.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      JiffyFormat.relativeTime(
                        story.createdAt.toIso8601String(),
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    if (story.lat != null && story.lon != null)
                      Text(
                        'Location: ${story.lat}, ${story.lon}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
