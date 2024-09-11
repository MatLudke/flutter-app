class CourseEntity {
  String? id;
  String? name;
  String? startAt;
  String? description;

  CourseEntity({this.id, this.name, this.startAt, this.description});

  static CourseEntity fromJson(Map<String, dynamic> map) {
    return CourseEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startAt: map['startAt'],
    );
  }

  static Map<String, dynamic> toJson(CourseEntity courseEntity) {
    return {
      'id': courseEntity.id,
      'name': courseEntity.name,
      'description': courseEntity.description,
      'startAt': courseEntity.startAt,
    };
  }
}
