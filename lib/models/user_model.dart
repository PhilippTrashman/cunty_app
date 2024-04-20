import 'package:intl/intl.dart';

class UserModel {
  String? id;
  String username;
  String password;
  String email;
  String role;
  DateTime? createdAt;
  String? firstName;
  String? lastName;
  DateTime? birthday;

  UserModel(
      {this.id,
      required this.username,
      required this.password,
      required this.role,
      this.firstName,
      this.lastName,
      required this.email,
      this.birthday,
      this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        role: json['role'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        birthday: json['birthday'],
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'birthday': birthday != null
            ? DateFormat('yyyy-MM-dd').format(birthday!).toString()
            : null,
        'created_at': createdAt != null
            ? DateFormat('yyyy-MM-dd').format(createdAt!).toString()
            : null,
      };

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, password: $password, role: $role, first_name: $firstName, last_name: $lastName, email: $email, birthday: $birthday, created_at: $createdAt)';
  }
}
