class SchoolClass {
  int? id;
  String name;
  int gradeId;

  SchoolClass({
    this.id,
    required this.name,
    required this.gradeId,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      name: json['name'],
      gradeId: json['grade_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'grade_id': gradeId,
      };

  @override
  String toString() => 'SchoolClass(id: $id, name: $name, grade_id: $gradeId)';
}
