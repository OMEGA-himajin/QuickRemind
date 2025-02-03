import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/subject_model.dart';

class SubjectController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SubjectModel>> fetchSubjects(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('subjects')
          .get();

      return snapshot.docs.map((doc) {
        return SubjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }
}
