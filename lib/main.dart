import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(App(prefs: prefs));

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class App extends StatefulWidget {
  const App({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppRouter appRouter;
  late SessionService sessionService;

  @override
  void initState() {
    sessionService = SessionService(prefs: widget.prefs);
    appRouter = AppRouter(sessionService);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        Provider(create: (context) => sessionService),
        ChangeNotifierProvider(
          create:
              (context) => SessionProvider(
                sessionService: sessionService,
                apiService: context.read<ApiService>(),
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => StoriesProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AddStoryProvider(context.read<ApiService>()),
        ),
      ],
      child: MaterialApp.router(routerConfig: appRouter.goRouter),
    );
  }
}
