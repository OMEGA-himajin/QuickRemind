import 'package:cloud_firestore/cloud_firestore.dart';

// メモデータを管理するモデル
class MemoModel {
  final String text;

  MemoModel({
    required this.text,
  });

  // Firestoreから取得したデータをオブジェクトに変換
  factory MemoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return MemoModel(
      text: data?['memo'] ?? '',
    );
  }

  // Firestoreに保存するためのMap変換
  Map<String, dynamic> toMap() {
    return {
      'memo': text,
    };
  }
}
