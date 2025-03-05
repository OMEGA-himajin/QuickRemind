import 'package:flutter/foundation.dart';
import '../model/subject_model.dart';
import '../controller/timetable_controller.dart';
import '../controller/subject_controller.dart';

class ConfirmCardController extends ChangeNotifier {
  final TimetableController _timetableController;
  final SubjectController _subjectController;

  ConfirmCardController({
    required TimetableController timetableController,
    required SubjectController subjectController,
  })  : _timetableController = timetableController,
        _subjectController = subjectController;

  // 今日の教科を取得
  Future<List<SubjectModel>> getTodaySubjects(String uid) async {
    await Future.wait([
      _timetableController.loadTimetable(uid),
      _subjectController.loadSubjects(uid),
    ]);

    final today = DateTime.now().weekday - 1;
    final todaySchedule =
        _timetableController.timetable?.getScheduleForDay(today) ?? [];

    return todaySchedule
        .where((subjectId) => subjectId.isNotEmpty)
        .map((subjectId) => _subjectController.subjects[subjectId])
        .where((subject) => subject != null)
        .cast<SubjectModel>()
        .toSet()
        .toList();
  }
}
