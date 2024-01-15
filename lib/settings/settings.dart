import 'package:cunty/src/imports.dart';

final log = Logger('APP_MODEL');

class SettingsRepository {
  final SharedPreferences preferences;

  SettingsRepository(this.preferences);

  Future<void> init() async {
    log.info('Loading shared preferences');
    await preferences.reload();
  }

  String get locale => preferences.getString('locale') ?? 'en';

  String get theme => preferences.getString('theme') ?? 'light';

  int? get username => preferences.getInt('username');

  bool get devmode => preferences.getBool('devmode') ?? false;

  Future<void> setLocale(String locale) async {
    await preferences.setString('locale', locale);
  }

  Future<void> setTheme(String theme) async {
    await preferences.setString('theme', theme);
  }

  Future<void> setUsername(int driverId) async {
    await preferences.setInt('username', driverId);
  }

  Future<void> setDevmode(bool devmode) async {
    await preferences.setBool('devmode', devmode);
  }

  Future<void> clear() async {
    await preferences.clear();
  }

  int? getUserId() {
    return username;
  }

  Future<void> saveSettings() async {
    await preferences.setString('locale', locale);
    await preferences.setString('theme', theme);
    if (username != null) {
      await preferences.setInt('username', username!);
    }
    await preferences.setBool('devmode', devmode);
    log.info('Saved settings.');
  }
}
