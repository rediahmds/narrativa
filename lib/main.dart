import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:narrativa/routes/routes.dart';
import 'package:narrativa/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(App(prefs: prefs));
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
    return MaterialApp.router(routerConfig: appRouter.goRouter);
  }
}
