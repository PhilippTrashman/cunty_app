import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  final String _baseUrl = dotenv.env['URL']!;
  final String _bearerToken = dotenv.env['TOKEN']!;

  static final Dio _dio = Dio();

  HttpService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_bearerToken',
    };
  }

  static Future<Response> get(String url) async {
    var response = await Dio().get(url);
    return response;
  }

  static Future<Response> post(String url, Map<String, dynamic> data) async {
    var response = await Dio().post(url, data: data);
    return response;
  }

  Future<Response> login(String email, String password) async {
    var response = await _dio.post('$_baseUrl/login',
        data: {'username': email, 'password': password});
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Response> fetchUsers() async {
    final response = await _dio.get('$_baseUrl/users');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> deleteUser(String username) async {
    final response = await _dio.delete('$_baseUrl/users/$username');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
