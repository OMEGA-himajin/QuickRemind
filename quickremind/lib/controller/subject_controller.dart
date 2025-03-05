import 'package:flutter/foundation.dart';
import '../model/subject_model.dart';
import '../repository/subject_repository.dart';

// 教科データを管理するコントローラー
class SubjectController extends ChangeNotifier {
  final SubjectRepository _repository;
  Map<String, SubjectModel> _subjects = {};

  SubjectController({required SubjectRepository repository})
      : _repository = repository;

  // 全ての教科データを取得
  Map<String, SubjectModel> get subjects => _subjects;

  // 教科データを読み込む
  Future<void> loadSubjects(String uid) async {
    try {
      _subjects = await _repository.fetchSubjects(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading subjects: $e');
      rethrow;
    }
  }

  // 教科名を取得
  String getSubjectName(String subjectId) {
    return _subjects[subjectId]?.name ?? '';
  }

  // 新しい教科を追加
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

  // 教科を削除
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

  // 持ち物を追加
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

  // 持ち物を削除
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
