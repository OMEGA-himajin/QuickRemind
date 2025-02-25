import '../model/timetable_model.dart';
import 'base_repository.dart';

// 時間割データのFirestore操作を管理するリポジトリ
class TimetableRepository extends BaseRepository {
  // 時間割データを取得
  Future<TimetableModel?> fetchTimetable(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('timetables')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return TimetableModel.fromMap(
        snapshot.docs.first.id, snapshot.docs.first.data());
  }

  // 時間割データを保存
  Future<void> saveTimetable(String uid, TimetableModel timetable) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('timetables')
        .doc(timetable.id)
        .set(timetable.toMap());
  }

  // 空の時間割を作成
  Future<void> createEmptyTimetable(String uid, int periods) async {
    final emptyTimetable = {
      'mon': List.filled(periods, ''),
      'tue': List.filled(periods, ''),
      'wed': List.filled(periods, ''),
      'thu': List.filled(periods, ''),
      'fri': List.filled(periods, ''),
      'sat': List.filled(periods, ''),
      'sun': List.filled(periods, ''),
    };
    await firestore
        .collection('users')
        .doc(uid)
        .collection('timetables')
        .add(emptyTimetable);
  }
}
