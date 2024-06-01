import 'dart:ui';

import 'package:cunty/src/imports.dart';
import 'package:cunty/screens/landing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void setupLogging() {
  Logger.root.level =
      Level.ALL; // Set this level to control which log messages are shown
  Logger.root.onRecord.listen((record) {});
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Future main() async {
  await dotenv.load(fileName: ".env");
  setupLogging();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppState()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Cunty',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          fontFamily: 'Roboto',
        ),
        home: const MainPage(),
      ),
    );
  }
}
