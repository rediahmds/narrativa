import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                                const Icon(
                                  Icons.broken_image_rounded,
                                  size: 48,
                                ),
                                const Text("Couldn't load image"),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      JiffyFormat.relativeTime(
                        story.createdAt.toIso8601String(),
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );

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
