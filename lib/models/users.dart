import 'package:cunty/models/school_grade.dart';

class UserSmall {
  final String id;
  final String name;
  final String lastName;
  final String username;
  final String birthday;

  UserSmall({
    required this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.birthday,
  });

  factory UserSmall.fromJson(Map<String, dynamic> json) {
    return UserSmall(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      username: json['username'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'username': username,
      'birthday': birthday,
    };
  }
}

class User {
  final String id;
  final String name;
  final String lastName;
  final String username;
  final String birthday;
  final String email;
  final Student? student;
  final Teacher? teacher;
  final Parent? parent;
  final SU? su;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.birthday,
    required this.email,
    this.student,
    this.teacher,
    this.parent,
    this.su,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      username: json['username'],
      birthday: json['birthday'],
      email: json['email'],
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      parent: json['parent'] != null ? Parent.fromJson(json['parent']) : null,
      su: json['su'] != null ? SU.fromJson(json['su']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'username': username,
      'birthday': birthday,
      'email': email,
      'student': student?.toJson(),
      'teacher': teacher?.toJson(),
      'parent': parent?.toJson(),
      'su': su?.toJson(),
    };
  }
}

class SU {
  final int id;
  final bool adminRights;
  final bool changeSubjectStatus;
  final bool manageUsers;
  final bool manageSchool;
  final UserSmall? account;

  SU({
    required this.id,
    required this.adminRights,
    required this.changeSubjectStatus,
    required this.manageUsers,
    required this.manageSchool,
    this.account,
  });

  factory SU.fromJson(Map<String, dynamic> json) {
    final account =
        json['account'] != null ? UserSmall.fromJson(json['account']) : null;
    return SU(
      id: json['id'],
      adminRights: json['admin_rights'],
      changeSubjectStatus: json['change_subject_status'],
      manageUsers: json['manage_users'],
      manageSchool: json['manage_school'],
      account: account,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_rights': adminRights,
      'change_subject_status': changeSubjectStatus,
      'manage_users': manageUsers,
      'manage_school': manageSchool,
      'account': account?.toJson(),
    };
  }
}

class Teacher {
  final int id;
  final String abbreviation;
  final UserSmall? account;
  final Map<int, SchoolClassSmall>? schoolClasses;

  Teacher({
    required this.id,
    required this.abbreviation,
    this.account,
    this.schoolClasses,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final account =
        json['account'] != null ? UserSmall.fromJson(json['account']) : null;
    Map<int, SchoolClassSmall> schoolClasses = {};
    if (json['school_class'] == null) {
      return Teacher(
        id: json['id'],
        abbreviation: json['abbreviation'],
        account: account,
      );
    }
    json['school_class'].forEach((key, value) {
      schoolClasses[int.parse(key)] = SchoolClassSmall.fromJson(value);
    });
    return Teacher(
      id: json['id'],
      abbreviation: json['abbreviation'],
      account: account,
      schoolClasses: schoolClasses,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> schoolClasses = {};
    this.schoolClasses?.forEach((key, value) {
      schoolClasses[key.toString()] = value.toJson();
    });
    return {
      'id': id,
      'abbreviation': abbreviation,
      'account': account?.toJson(),
      'school_classes': schoolClasses,
    };
  }
}

class ParenttoStudentLink {
  final int id;
  final Parent parent;

  ParenttoStudentLink({
    required this.id,
    required this.parent,
  });

  factory ParenttoStudentLink.fromJson(Map<String, dynamic> json) {
    return ParenttoStudentLink(
      id: json['id'],
      parent: Parent.fromJson(json['parent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent': parent.toJson(),
    };
  }
}

class Parent {
  final int id;
  final UserSmall? account;

  Parent({
    required this.id,
    required this.account,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    final account =
        json['account'] != null ? UserSmall.fromJson(json['account']) : null;
    return Parent(
      id: json['id'],
      account: account,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account?.toJson(),
    };
  }
}

class Student {
  final int id;
  final int schoolClassId;
  final SchoolClassSmall schoolClass;
  final Map<int, ParenttoStudentLink> parents;
  final UserSmall? account;

  Student({
    required this.id,
    required this.schoolClassId,
    required this.schoolClass,
    required this.parents,
    this.account,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    Map<int, ParenttoStudentLink> parents = {};
    json['parents'].forEach((key, value) {
      parents[int.parse(key)] = ParenttoStudentLink.fromJson(value);
    });
    final account =
        json['account'] != null ? UserSmall.fromJson(json['account']) : null;
    return Student(
      id: json['id'],
      schoolClassId: json['school_class_id'],
      schoolClass: SchoolClassSmall.fromJson(json['school_class']),
      parents: parents,
      account: account,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> parents = {};
    this.parents.forEach((key, value) {
      parents[key.toString()] = value.toJson();
    });
    return {
      'id': id,
      'school_class_id': schoolClassId,
      'school_class': schoolClass.toJson(),
      'parents': parents,
      'account': account?.toJson(),
    };
  }
}
