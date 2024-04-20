class GradeModel {
  final String? id;
  final String name;
  final String description;
  final String createdAt;

  GradeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'created_at': createdAt,
      };

  @override
  String toString() {
    return 'GradeModel(id: $id, name: $name, description: $description, created_at: $createdAt)';
  }
}
