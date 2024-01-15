import 'package:cunty/src/imports.dart';

class MyAppState extends ChangeNotifier {
  static final log = Logger('APP_MODEL');
  BoxConstraints constraints = const BoxConstraints();
  late double windowWidth;
  late double windowHeight;
  bool devMode = false;

  MyAppState() {
    SharedPreferences.getInstance().then((prefs) {
      devMode = prefs.getBool('devmode') ?? false;
      notifyListeners();
    });
  }

  void toggleDevMode() {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('devmode', !devMode).then((value) {
              devMode = !devMode;
              notifyListeners();
            }));
  }

  String lastPage = "/landing";

  Future<void> init() async {
    windowWidth = constraints.maxWidth;
    windowHeight = constraints.maxHeight;
  }

  void setLastPage(String page) {
    lastPage = page;
    notifyListeners();
  }

  void setWindowWidth(double width) {
    windowWidth = width;
    notifyListeners();
  }

  String getLastPage() {
    return lastPage;
  }

  double getMaxWidth() {
    return windowWidth;
  }
}
