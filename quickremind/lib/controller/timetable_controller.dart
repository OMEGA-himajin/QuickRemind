import 'package:flutter/foundation.dart';
import '../model/timetable_model.dart';
import '../repository/timetable_repository.dart';

// 時間割データを管理するコントローラー
class TimetableController extends ChangeNotifier {
  final TimetableRepository _repository;
  TimetableModel? _timetable;

  TimetableController({required TimetableRepository repository})
      : _repository = repository;

  // 現在の時間割データを取得
  TimetableModel? get timetable => _timetable;

  // 時間割データを読み込む
  Future<void> loadTimetable(String uid) async {
    try {
      _timetable = await _repository.fetchTimetable(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading timetable: $e');
      rethrow;
    }
  }

  // 指定したセルの教科を更新
  //
  // [uid] ユーザーID
  // [day] 曜日(0-6)
  // [period] 時限
  // [subjectId] 設定する教科ID
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

  // 指定したセルの教科IDを取得
  String? getSubjectIdForCell(int day, int period) {
    return _timetable?.getSubjectIdForCell(day, period);
  }

  // 空の時間割を作成
  Future<void> addEmptyTimetable(String uid) async {
    try {
      await _repository.createEmptyTimetable(uid, 6);
      await loadTimetable(uid);
    } catch (e) {
      print('Error adding empty timetable: $e');
      rethrow;
    }
  }
}
