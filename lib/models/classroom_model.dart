class ClassroomModel {
  int? id;
  String name;
  String description;

  ClassroomModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  @override
  String toString() {
    return 'ClassroomModel(id: $id, name: $name, description: $description)';
  }
}
