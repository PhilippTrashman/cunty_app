class PeriodModel {
  final int id;
  final String name;
  final String description;
  final String teacherId;
  final String createdAt;
  final String updatedAt;
  final String status = 'active';

  PeriodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      teacherId: json['teacher_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'teacher_id': teacherId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  @override
  String toString() {
    return 'PeriodModel(id: $id, name: $name, description: $description, teacher_id: $teacherId, created_at: $createdAt, updated_at: $updatedAt)';
  }
}
