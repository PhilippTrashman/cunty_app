import 'package:cunty/models/users.dart';

class SchoolGradeSmall {
  final int id;
  final int year;

  SchoolGradeSmall({
    required this.id,
    required this.year,
  });

  int get grade {
    return DateTime.now().year - year;
  }

  factory SchoolGradeSmall.fromJson(Map<String, dynamic> json) {
    return SchoolGradeSmall(
      id: json['id'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
    };
  }
}

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
}

class SchoolClassSmall {
  final int id;
  final String name;
  final int gradeId;
  final int gradeYear;
  final int headTeacherId;
  final String headTeacherName;
  final String headTeacherAbbreviation;

  int get grade {
    return DateTime.now().year - gradeYear;
  }

  SchoolClassSmall({
    required this.id,
    required this.name,
    required this.gradeId,
    required this.gradeYear,
    required this.headTeacherId,
    required this.headTeacherName,
    required this.headTeacherAbbreviation,
  });

  factory SchoolClassSmall.fromJson(Map<String, dynamic> json) {
    return SchoolClassSmall(
      id: json['id'],
      name: json['name'],
      gradeId: json['grade_id'],
      gradeYear: json['grade_year'],
      headTeacherId: json['head_teacher_id'],
      headTeacherName: json['head_teacher_name'],
      headTeacherAbbreviation: json['head_teacher_abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade_id': gradeId,
      'grade_year': gradeYear,
      'head_teacher_id': headTeacherId,
      'head_teacher_name': headTeacherName,
      'head_teacher_abbreviation': headTeacherAbbreviation,
    };
  }
}

class SchoolClass {
  final int id;
  final String name;
  final int gradeId;
  final int gradeYear;
  final int headTeacherId;
  final String headTeacherName;
  final String headTeacherAbbreviation;
  final SchoolClassHeadTeacher headTeacher;
  final Map<int, SchoolClassStudent> students;

  int get grade {
    return DateTime.now().year - gradeYear;
  }

  SchoolClass({
    required this.id,
    required this.name,
    required this.gradeId,
    required this.gradeYear,
    required this.headTeacherId,
    required this.headTeacherName,
    required this.headTeacherAbbreviation,
    required this.headTeacher,
    required this.students,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      name: json['name'],
      gradeId: json['grade_id'],
      gradeYear: json['grade_year'],
      headTeacherId: json['head_teacher_id'],
      headTeacherName: json['head_teacher_name'],
      headTeacherAbbreviation: json['head_teacher_abbreviation'],
      headTeacher: SchoolClassHeadTeacher.fromJson(json['head_teacher']),
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
      'grade_id': gradeId,
      'grade_year': gradeYear,
      'head_teacher_id': headTeacherId,
      'head_teacher_name': headTeacherName,
      'head_teacher_abbreviation': headTeacherAbbreviation,
      'head_teacher': headTeacher.toJson(),
      'students': students,
    };
  }
}

class SchoolClassHeadTeacher {
  final int id;
  final String abbreviation;
  final UserSmall account;

  SchoolClassHeadTeacher({
    required this.id,
    required this.abbreviation,
    required this.account,
  });

  factory SchoolClassHeadTeacher.fromJson(Map<String, dynamic> json) {
    return SchoolClassHeadTeacher(
      id: json['id'],
      abbreviation: json['abbreviation'],
      account: UserSmall.fromJson(json['account']),
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
  final UserSmall account;

  SchoolClassStudent({
    required this.id,
    required this.schoolClassId,
    required this.account,
  });

  factory SchoolClassStudent.fromJson(Map<String, dynamic> json) {
    return SchoolClassStudent(
      id: json['id'],
      schoolClassId: json['school_class_id'],
      account: UserSmall.fromJson(json['account']),
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
