import 'package:go_router/go_router.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/screens/screens.dart';
import 'package:narrativa/services/services.dart';

class AppRouter {
  AppRouter(this._sessionService);

  final SessionService _sessionService;

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppPaths.login.path,
        builder:
            (context, state) => LoginScreen(
              onLogin: () {
                context.go(AppPaths.home.path);
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
                context.go(AppPaths.home.path);
              },
              onLogin: () {
                context.go(AppPaths.login.path);
              },
            ),
      ),
      GoRoute(
        path: AppPaths.home.path,
        builder:
            (context, state) => StoriesScreen(
              onLogout: () async {
                await _sessionService.clearSession();
                context.go(AppPaths.login.path);
              },
              onStoryTap: (String storyId) {
                context.go("${AppPaths.stories.path}/$storyId");
              },
            ),
        routes: [
          GoRoute(
            path: "${AppPaths.stories.path}/:id",
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
