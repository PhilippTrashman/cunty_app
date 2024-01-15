import 'package:cunty/src/imports.dart';
import 'package:cunty/screens/landing.dart';

void setupLogging() {
  Logger.root.level =
      Level.ALL; // Set this level to control which log messages are shown
  Logger.root.onRecord.listen((record) {});
}

void main() {
  setupLogging();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MyAppState()),
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
        ChangeNotifierProvider<MyAppState>(
          create: (context) => MyAppState(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
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
