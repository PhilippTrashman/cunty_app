class UserLogin {
  String? id;
  String username;
  String password;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? birthday;
  DateTime? creationDate;

  UserLogin({
    this.id,
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.creationDate
  });
}
