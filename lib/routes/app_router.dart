import 'package:go_router/go_router.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/screens/screens.dart';
import 'package:narrativa/services/services.dart';
import 'package:provider/provider.dart';

class AppRouter {
  AppRouter(this._sessionService);

  final SessionService _sessionService;

  late final GoRouter router = GoRouter(
    initialLocation: AppPaths.stories.path,
    routes: [
      GoRoute(
        path: AppPaths.login.path,
        builder:
            (context, state) => LoginScreen(
              onLogin: () {
                context.go(AppPaths.stories.path);
              },
              onRegister: () {
                context.go(AppPaths.register.path);
              },
            ),
      ),
      GoRoute(
        path: AppPaths.register.path,
        builder:
            (context, state) => RegisterScreen(
              onRegister: () {
                context.go(AppPaths.stories.path);
              },
              onLogin: () {
                context.go(AppPaths.login.path);
              },
            ),
      ),
      GoRoute(
        path: AppPaths.stories.path,
        builder:
            (context, state) => StoriesScreen(
              onLogout: () async {
                await _sessionService.clearSession();
                context.go(AppPaths.login.path);
              },
              onStoryTap: (String storyId) {
                context.go("${AppPaths.stories.path}/$storyId");
              },
              onAddStory: () async {
                final isRefresh = await context.push<bool>(
                  "${AppPaths.stories.path}/add",
                );
                if (isRefresh == true && context.mounted) {
                  final loginResult = _sessionService.loadSession();
                  final token = loginResult?.token;
                  if (token != null) {
                    context.read<StoriesProvider>().fetchStories(token);
                  }
                }
              },
            ),
        routes: [
          GoRoute(
            path: "/add",
            builder:
                (context, state) => AddStoryScreen(
                  onLogout: () {
                    context.go(AppPaths.login.path);
                  },
                  onUploaded: () {
                    context.pop(true);
                  },
                ),
          ),
          GoRoute(
            path: "/:id",
            builder:
                (context, state) => DetailScreen(
                  storyId: state.pathParameters["id"]!,
                  onLogout: () {
                    context.go(AppPaths.login.path);
                  },
                ),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final session = _sessionService.loadSession();
      final isLoggedIn = session != null;

      if (!isLoggedIn &&
          state.matchedLocation != AppPaths.login.path &&
          state.matchedLocation != AppPaths.register.path) {
        return AppPaths.login.path;
      }

      return null;
    },
  );

  GoRouter get goRouter => router;
}
