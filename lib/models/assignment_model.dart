import 'package:cunty/models/class_model.dart';
import 'package:cunty/models/user_model.dart';

class AssignmentModel {
  final String title;
  final String description;
  final String dueDate;
  final String subject;
  final UserModel teacher;
  final SchoolClass schoolClass;
  final String status;

  AssignmentModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.subject,
    required this.teacher,
    required this.schoolClass,
    required this.status,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
      subject: json['subject'],
      teacher: json['teacher'],
      schoolClass: json['school_class'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'subject': subject,
        'teacher_id': teacher.id!,
        'school_class_id': schoolClass.id!,
        'status': status,
      };

  @override
  String toString() {
    return 'AssignemntModel(title: $title, description: $description, dueDate: $dueDate, subject: $subject, teacher_id: $teacher, classRoom: $schoolClass, status: $status)';
  }
}
