import 'package:flutter/foundation.dart';
import '../model/timetable_model.dart';
import '../repository/timetable_repository.dart';

class TimetableController extends ChangeNotifier {
  final TimetableRepository _repository;
  TimetableModel? _timetable;

  TimetableController({required TimetableRepository repository})
      : _repository = repository;

  TimetableModel? get timetable => _timetable;

  Future<void> loadTimetable(String uid) async {
    try {
      _timetable = await _repository.fetchTimetable(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading timetable: $e');
      rethrow;
    }
  }

  Future<void> updateCell(
      String uid, int day, int period, String subjectId) async {
    try {
      if (_timetable != null) {
        _timetable!.updateCell(day, period, subjectId);
        await _repository.saveTimetable(uid, _timetable!);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating cell: $e');
      rethrow;
    }
  }

  String? getSubjectIdForCell(int day, int period) {
    return _timetable?.getSubjectIdForCell(day, period);
  }

  Future<void> addEmptyTimetable(String uid) async {
    try {
      await _repository.createEmptyTimetable(uid, 6); // デフォルトの時限数を6に設定
      await loadTimetable(uid); // 作成後に読み込む
    } catch (e) {
      print('Error adding empty timetable: $e');
      rethrow;
    }
  }
}
