import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/subject_model.dart';
import 'base_repository.dart';

class SubjectRepository extends BaseRepository {
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

  Future<void> deleteSubject(String uid, String subjectId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId)
        .delete();
  }

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
