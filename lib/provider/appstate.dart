import 'package:cunty/src/imports.dart';
import 'package:cunty/service/http_service.dart';
import 'package:cunty/models/users.dart';

class AppState extends ChangeNotifier {
  static final log = Logger('APP_MODEL');
  BoxConstraints constraints = const BoxConstraints();
  late double windowWidth;
  late double windowHeight;
  bool devMode = false;

  static User? _user;

  User? get user => _user;

  final HttpService _httpService = HttpService();

  AppState() {
    SharedPreferences.getInstance().then((prefs) {
      devMode = prefs.getBool('devmode') ?? false;
      notifyListeners();
    });
  }

  bool loggedIn() {
    return _user != null;
  }

  Future<void> login(String email, String password) async {
    try {
      await _httpService.login(email, password).then((response) {
        Map<String, dynamic> data = json.decode(response.data);
        _user = User.fromJson(data);
        notifyListeners();
      });
    } catch (e) {
      log.warning('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
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
