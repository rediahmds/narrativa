import 'package:flutter/material.dart';
import 'package:narrativa/models/models.dart';

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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      story.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Created at: ${story.createdAt.toLocal()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (story.lat != null && story.lon != null)
                      Text(
                        'Location: ${story.lat}, ${story.lon}',
                        style: Theme.of(context).textTheme.bodyMedium,
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
