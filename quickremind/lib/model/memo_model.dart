class MemoModel {
  String memo;

  MemoModel({required this.memo});

  // Firestore から取得したデータを MemoModel に変換
  factory MemoModel.fromMap(Map<String, dynamic> data) {
    return MemoModel(memo: data['memo'] ?? '');
  }

  // Firestore に保存するための Map 形式
  Map<String, dynamic> toMap() {
    return {'memo': memo};
  }
}
