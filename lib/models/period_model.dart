class PeriodModel {
  final String id;
  final String name;
  final String description;
  final String teacherId;
  final String startDate;
  final String endDate;
  final String createdAt;
  final String updatedAt;

  PeriodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      teacherId: json['teacher_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'teacher_id': teacherId,
        'start_date': startDate,
        'end_date': endDate,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  @override
  String toString() {
    return 'PeriodModel(id: $id, name: $name, description: $description, teacher_id: $teacherId, start_date: $startDate, end_date: $endDate, created_at: $createdAt, updated_at: $updatedAt)';
  }
}
