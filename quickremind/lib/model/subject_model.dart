class SubjectModel {
  final String id;
  final String name;
  final List<String> items;

  SubjectModel({
    required this.id,
    required this.name,
    required this.items,
  });

  factory SubjectModel.fromMap(String id, Map<String, dynamic> data) {
    return SubjectModel(
      id: id,
      name: data['name'] ?? '',
      items: List<String>.from(data['items'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'items': items,
    };
  }
}
