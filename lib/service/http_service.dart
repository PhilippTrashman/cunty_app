import 'package:dio/dio.dart';

class HttpService {
  static const _baseUrl = 'http://127.0.0.1:8000';
  static const _bearerToken = '';

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
    var response = await Dio().post('$_baseUrl/login',
        data: {'username': email, 'password': password});
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Failed to login');
    }
  }
}
