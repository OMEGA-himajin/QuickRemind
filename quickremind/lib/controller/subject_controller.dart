import '../model/subject_model.dart';
import 'package:flutter/foundation.dart';
import '../repository/subject_repository.dart';

class SubjectController extends ChangeNotifier {
  final SubjectRepository _repository;
  Map<String, SubjectModel> _subjects = {};

  SubjectController({required SubjectRepository repository})
      : _repository = repository;

  Map<String, SubjectModel> get subjects => _subjects;

  Future<void> loadSubjects(String uid) async {
    try {
      _subjects = await _repository.fetchSubjects(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading subjects: $e');
      rethrow;
    }
  }

  String getSubjectName(String subjectId) {
    return _subjects[subjectId]?.name ?? '';
  }

  Future<void> addSubject(String uid, String name) async {
    try {
      final subject = await _repository.createSubject(uid, name);
      _subjects[subject.id] = subject;
      notifyListeners();
    } catch (e) {
      print('Error adding subject: $e');
      rethrow;
    }
  }

  Future<void> removeSubject(String uid, String subjectId) async {
    try {
      await _repository.deleteSubject(uid, subjectId);
      _subjects.remove(subjectId);
      notifyListeners();
    } catch (e) {
      print('Error removing subject: $e');
      rethrow;
    }
  }

  Future<void> addItem(String uid, String subjectId, String itemName) async {
    try {
      await _repository.addItem(uid, subjectId, itemName);
      _subjects[subjectId]?.items.add(itemName);
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  Future<void> removeItem(String uid, String subjectId, String itemName) async {
    try {
      await _repository.removeItem(uid, subjectId, itemName);
      _subjects[subjectId]?.items.remove(itemName);
      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
      rethrow;
    }
  }
}
