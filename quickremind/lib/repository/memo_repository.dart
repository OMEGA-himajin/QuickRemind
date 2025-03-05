import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/memo_model.dart';
import 'base_repository.dart';

// メモデータのFirestore操作を管理するリポジトリ
class MemoRepository extends BaseRepository {
  // メモを取得
  Future<MemoModel> fetchMemo(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return MemoModel.fromFirestore(doc);
  }

  // メモを保存
  Future<void> saveMemo(String uid, MemoModel memo) async {
    await firestore
        .collection('users')
        .doc(uid)
        .set(memo.toMap(), SetOptions(merge: true));
  }
}
