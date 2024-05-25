import 'package:cunty/src/imports.dart';
import 'package:cunty/service/http_service.dart';

class AppState extends ChangeNotifier {
  static final log = Logger('APP_MODEL');
  BoxConstraints constraints = const BoxConstraints();
  late double windowWidth;
  late double windowHeight;
  bool devMode = false;

  static String? _userId;

  final HttpService _httpService = HttpService();
  bool loggedIn() {
    return _userId == null;
  }

  set userId(String? value) {
    _userId = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      await _httpService.login(email, password).then((response) {
        userId = response.data['user']['id'];
        notifyListeners();
      });
    } catch (e) {
      log.warning('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    userId = null;
    notifyListeners();
  }

  AppState() {
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

  Future<void> init() async {
    windowWidth = constraints.maxWidth;
    windowHeight = constraints.maxHeight;
  }

  void setWindowWidth(double width) {
    windowWidth = width;
    notifyListeners();
  }

  double getMaxWidth() {
    return windowWidth;
  }
}
