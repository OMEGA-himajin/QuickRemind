// 教科データを管理するモデル
class SubjectModel {
  final String id;
  final String name;
  final List<String> items;

  SubjectModel({
    required this.id,
    required this.name,
    required this.items,
  });

  // Firestoreから取得したデータをオブジェクトに変換
  factory SubjectModel.fromMap(String id, Map<String, dynamic> data) {
    return SubjectModel(
      id: id,
      name: data['name'] ?? '',
      items: List<String>.from(data['items'] ?? []),
    );
  }

  // Firestoreに保存するためのMap変換
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'items': items,
    };
  }
}
