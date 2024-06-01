class SchoolGrade {
  final int id;
  final int year;
  final Map<int, SchoolClassSmall> classes;

  SchoolGrade({
    required this.id,
    required this.year,
    required this.classes,
  });

  int get grade {
    return DateTime.now().year - year;
  }

  factory SchoolGrade.fromJson(Map<String, dynamic> json) {
    return SchoolGrade(
      id: json['id'],
      year: json['year'],
      classes: (json['classes'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(int.parse(key), SchoolClassSmall.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'classes': classes,
    };
  }

  @override
  String toString() {
    return 'SchoolGrade{id: $id, year: $year, classes: $classes}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchoolGrade &&
        other.id == id &&
        other.year == year &&
        other.classes == classes;
  }
}

class SchoolClassSmall {
  final int id;
  final String name;
  final int grade_id;
  final int grade_year;
  final int head_teacher_id;
  final String head_teacher_name;
  final String head_teacher_abbreviation;

  int get grade {
    return DateTime.now().year - grade_year;
  }

  SchoolClassSmall({
    required this.id,
    required this.name,
    required this.grade_id,
    required this.grade_year,
    required this.head_teacher_id,
    required this.head_teacher_name,
    required this.head_teacher_abbreviation,
  });

  factory SchoolClassSmall.fromJson(Map<String, dynamic> json) {
    return SchoolClassSmall(
      id: json['id'],
      name: json['name'],
      grade_id: json['grade_id'],
      grade_year: json['grade_year'],
      head_teacher_id: json['head_teacher_id'],
      head_teacher_name: json['head_teacher_name'],
      head_teacher_abbreviation: json['head_teacher_abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade_id': grade_id,
      'grade_year': grade_year,
      'head_teacher_id': head_teacher_id,
      'head_teacher_name': head_teacher_name,
      'head_teacher_abbreviation': head_teacher_abbreviation,
    };
  }
}

class SchoolClass {
  final int id;
  final String name;
  final int grade_id;
  final int grade_year;
  final int head_teacher_id;
  final String head_teacher_name;
  final String head_teacher_abbreviation;
  final SchoolClassHeadTeacher head_teacher;
  final Map<int, SchoolClassStudent> students;

  int get grade {
    return DateTime.now().year - grade_year;
  }

  SchoolClass({
    required this.id,
    required this.name,
    required this.grade_id,
    required this.grade_year,
    required this.head_teacher_id,
    required this.head_teacher_name,
    required this.head_teacher_abbreviation,
    required this.head_teacher,
    required this.students,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      name: json['name'],
      grade_id: json['grade_id'],
      grade_year: json['grade_year'],
      head_teacher_id: json['head_teacher_id'],
      head_teacher_name: json['head_teacher_name'],
      head_teacher_abbreviation: json['head_teacher_abbreviation'],
      head_teacher: SchoolClassHeadTeacher.fromJson(json['head_teacher']),
      students: (json['students'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(int.parse(key), SchoolClassStudent.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade_id': grade_id,
      'grade_year': grade_year,
      'head_teacher_id': head_teacher_id,
      'head_teacher_name': head_teacher_name,
      'head_teacher_abbreviation': head_teacher_abbreviation,
      'head_teacher': head_teacher.toJson(),
      'students': students,
    };
  }
}

class SchoolClassHeadTeacher {
  final int id;
  final String abbreviation;
  final SchoolClassStudentAccount account;

  SchoolClassHeadTeacher({
    required this.id,
    required this.abbreviation,
    required this.account,
  });

  factory SchoolClassHeadTeacher.fromJson(Map<String, dynamic> json) {
    return SchoolClassHeadTeacher(
      id: json['id'],
      abbreviation: json['abbreviation'],
      account: SchoolClassStudentAccount.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'abbreviation': abbreviation,
      'account': account.toJson(),
    };
  }
}

class SchoolClassStudent {
  final int id;
  final int schoolClassId;
  final SchoolClassStudentAccount account;

  SchoolClassStudent({
    required this.id,
    required this.schoolClassId,
    required this.account,
  });

  factory SchoolClassStudent.fromJson(Map<String, dynamic> json) {
    return SchoolClassStudent(
      id: json['id'],
      schoolClassId: json['school_class_id'],
      account: SchoolClassStudentAccount.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_class_id': schoolClassId,
      'account': account.toJson(),
    };
  }
}

class SchoolClassStudentAccount {
  final String id;
  final String username;
  final String name;
  final String lastName;
  final String birthday;

  SchoolClassStudentAccount({
    required this.id,
    required this.username,
    required this.name,
    required this.lastName,
    required this.birthday,
  });

  factory SchoolClassStudentAccount.fromJson(Map<String, dynamic> json) {
    return SchoolClassStudentAccount(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      lastName: json['last_name'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'last_name': lastName,
      'birthday': birthday,
    };
  }
}
