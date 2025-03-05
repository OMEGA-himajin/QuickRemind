import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/subject_model.dart';
import 'base_repository.dart';

// 教科データのFirestore操作を管理するリポジトリ
class SubjectRepository extends BaseRepository {
  // 全ての教科データを取得
  Future<Map<String, SubjectModel>> fetchSubjects(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .get();
    return {
      for (var doc in snapshot.docs)
        doc.id: SubjectModel.fromMap(doc.id, doc.data())
    };
  }

  // 新しい教科を作成
  Future<SubjectModel> createSubject(String uid, String name) async {
    final docRef = await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .add({
      'name': name,
      'items': [],
    });
    return SubjectModel(id: docRef.id, name: name, items: []);
  }

  // 教科を削除
  Future<void> deleteSubject(String uid, String subjectId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId)
        .delete();
  }

  // 教科に関連した持ち物を追加
  Future<void> addItem(String uid, String subjectId, String itemName) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId)
        .update({
      'items': FieldValue.arrayUnion([itemName])
    });
  }

  // 教科に関連した持ち物を削除
  Future<void> removeItem(String uid, String subjectId, String itemName) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId)
        .update({
      'items': FieldValue.arrayRemove([itemName])
    });
  }
}
