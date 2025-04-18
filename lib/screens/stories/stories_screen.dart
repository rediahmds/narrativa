import 'package:flutter/material.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/static/static.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key, required this.onLogout});

  final Function onLogout;

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
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
      context.read<StoriesProvider>().fetchStories(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories')),
      body: Consumer<StoriesProvider>(
        builder: (_, storiesProvider, _) {
          switch (storiesProvider.state.status) {
            case StoriesStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case StoriesStatus.loaded:
              final stories = storiesProvider.state.stories;

              if (stories == null || stories.isEmpty) {
                return const Center(child: Text('No stories available.'));
              }

              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return ListTile(
                    title: Text(story.name),
                    subtitle: Text(story.description),
                  );
                },
              );

            default:
              return Center(
                child: Text(
                  storiesProvider.state.errorMessage ?? 'An error occurred.',
                ),
              );
          }
        },
      ),
    );
  }
}
