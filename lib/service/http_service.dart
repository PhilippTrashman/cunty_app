import 'package:cunty/models/users.dart';
import 'package:cunty/src/imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cunty/models/school_grade.dart';

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

  static _responseToList(Response response) {
    return (json.decode(response.data) as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchObject(String table) async {
    final response = await _dio.get('$_baseUrl/$table');
    List<Map<String, dynamic>> data = [];
    if (response.statusCode == 200) {
      data = _responseToList(response);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    return fetchObject('users');
  }

  Future<User> fetchUser(String username) async {
    final response = await _dio.get('$_baseUrl/users/$username');
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static const testAccountList = [
    'testStudent1',
    'testStudent2',
    'testTeacher1',
    'testTeacher2',
    'testParent1',
    'testParent2',
    'testSU',
  ];

  Future<Response> addUser(NewUser user) async {
    if (testAccountList.contains(user.username)) {
      throw TestAccountException();
    }
    final response = await _dio.post('$_baseUrl/users', data: user.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<Response> deleteUser(String username) async {
    if (testAccountList.contains(username)) {
      throw TestAccountException();
    }
    final response = await _dio.delete('$_baseUrl/users/$username');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete user');
    }
  }

  Future<Response> updateUser(User user, String username) async {
    final response =
        await _dio.put('$_baseUrl/users/$username', data: user.toUpdateJson());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<Response> deleteUserRoll(String roll, String username) async {
    if (!['su', 'student', 'teacher', 'parent'].contains(roll)) {
      throw Exception('Invalid roll');
    }
    final response = await _dio.delete('$_baseUrl/users/$username/$roll');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete user roll');
    }
  }

  Future<List<Map<String, dynamic>>> fetchStudents() async {
    return fetchObject('students');
  }

  Future<List<Map<String, dynamic>>> fetchTeachers() async {
    return fetchObject('teachers');
  }

  Future<List<Map<String, dynamic>>> fetchParents() async {
    return fetchObject('parents');
  }

  Future<List<Map<String, dynamic>>> fetchAdmins() async {
    return fetchObject('su');
  }

  Future<List<SchoolGradeSmall>> fetchGrades() async {
    final response = await _dio.get('$_baseUrl/school_grade');
    List<SchoolGradeSmall> data = [];
    if (response.statusCode == 200) {
      data = (json.decode(response.data) as List)
          .map((item) => SchoolGradeSmall.fromJson(item))
          .toList();
      data.sort((a, b) => a.grade.compareTo(b.grade));
      return data;
    } else {
      throw Exception('Failed to load grades');
    }
  }

  Future<SchoolGrade> fetchGrade(int id) async {
    debugPrint('Fetching grade $id');
    final response = await _dio.get('$_baseUrl/school_grade/$id');
    if (response.statusCode == 200) {
      return SchoolGrade.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to load grade');
    }
  }

  Future<SchoolClass> fetchClass(int id) async {
    final response = await _dio.get('$_baseUrl/school_classes/$id');
    if (response.statusCode == 200) {
      return SchoolClass.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to load class');
    }
  }
}

class TestAccountException implements Exception {
  String errorMessage() {
    return 'Cannot delete test account';
  }
}
