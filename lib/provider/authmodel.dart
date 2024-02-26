import 'package:cunty/src/imports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


// Create a new ChangeNotifier class
class AuthModel extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  // Create a private variable to store the user's token
  String? _userId;

  // Create a getter to access the user's token
  String? get userId => _userId;

  // Create a method to update the user's token
  void setUserId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  // Create a method to log the user out
  void logout() {
    _userId = null;
    storage.delete(key: 'token');
    notifyListeners();
  }

  // Create a method to log the user in
  Future<void> login(String email, String password) async {
    // Make a network request to log the user in
    final response = await http.post(
      Uri.parse('https://example.com/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    // If the request is successful, update the user's token
    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'token', value: token);
      setUserId(token);
    }
  }

  // Create a method to check if the user is logged in
  Future<void> checkLogin() async {
    final token = await storage.read(key: 'token');
    if (token != null) {
      setUserId(token);
    }

    notifyListeners();
  }
}
