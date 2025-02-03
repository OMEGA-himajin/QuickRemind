import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/memo_model.dart';

class MemoController {
  final String uid;
  MemoController({required this.uid});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore からメモを取得
  Future<MemoModel> fetchMemo() async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return MemoModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return MemoModel(memo: ''); // デフォルト値
    }
  }

  // Firestore にメモを保存
  Future<void> saveMemo(String memo) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'memo': memo}, SetOptions(merge: true));
  }
}
