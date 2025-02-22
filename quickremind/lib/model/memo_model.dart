import 'package:cloud_firestore/cloud_firestore.dart';

class MemoModel {
  final String text;

  MemoModel({
    required this.text,
  });

  factory MemoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return MemoModel(
      text: data?['memo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memo': text,
    };
  }
}
