import 'package:flutter/material.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/static/static.dart';
import 'package:narrativa/ui/ui.dart';
import 'package:provider/provider.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({
    super.key,
    required this.onLogout,
    required this.onStoryTap,
    required this.onAddStory,
  });

  final Function onLogout;
  final Function onAddStory;
  final void Function(String) onStoryTap;

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final sessionState = context.read<SessionProvider>().state;
    final token = sessionState.loginResult?.token;

    if (token == null) {
      widget.onLogout();
      return;
    }

    final storiesProvider = context.read<StoriesProvider>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          storiesProvider.page != null) {
        storiesProvider.fetchStories(token);
      }
    });

    Future.microtask(() async {
      storiesProvider.fetchStories(token);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.red,
            tooltip: "Logout",
            onPressed: () async {
              final sessionProvider = context.read<SessionProvider>();
              await sessionProvider.logout();

              widget.onLogout();
            },
          ),
        ],
      ),
      body: Consumer<StoriesProvider>(
        builder: (_, storiesProvider, _) {
          switch (storiesProvider.state.status) {
            case StoriesStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case StoriesStatus.loaded:
              final stories = storiesProvider.state.stories;

              if (stories == null || stories.isEmpty) {
                // !FIX: Showing empty state after adding a story
                return const Center(child: Text('No stories available.'));
              }

              int addedPages = storiesProvider.page != null ? 1 : 0;
              return ListView.builder(
                controller: _scrollController,
                itemCount: stories.length + addedPages,
                itemBuilder: (context, index) {
                  if (index == stories.length && storiesProvider.page != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final story = stories[index];
                  return StoryCardWidget(
                    story: story,
                    onTap: () => widget.onStoryTap(story.id),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            widget.onAddStory();
          },
          tooltip: "Add Story",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
