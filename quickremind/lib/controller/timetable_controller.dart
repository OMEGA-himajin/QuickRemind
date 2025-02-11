import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickremind/model/timetable_model.dart';
import 'package:quickremind/model/subject_model.dart';
import 'package:quickremind/model/settings_model.dart';

class TimetableController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimetableModel? _timetable;
  Map<String, SubjectModel> _subjects = {};
  SettingsModel? _settings;
  String _memo = '';

  TimetableModel? get timetable => _timetable;
  Map<String, SubjectModel> get subjects => _subjects;
  SettingsModel? get settings => _settings;
  String get memo => _memo;

  Future<void> loadTimetable(String uid) async {
    final timetableDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('timetables')
        .limit(1)
        .get();
    if (timetableDoc.docs.isNotEmpty) {
      _timetable = TimetableModel.fromMap(
          timetableDoc.docs.first.id, timetableDoc.docs.first.data());
      _timetable!.ensureSize(_settings?.period ?? 4);
      notifyListeners();
    } else {
      await addEmptyTimetable(uid);
      await loadTimetable(uid);
    }
  }

  Future<void> loadSubjects(String uid) async {
    final subjectsSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .get();
    _subjects = {
      for (var doc in subjectsSnapshot.docs)
        doc.id: SubjectModel.fromMap(doc.id, doc.data())
    };
    notifyListeners();
  }

  Future<void> loadSettings(String uid) async {
    final settingsDoc = await _firestore.collection('users').doc(uid).get();
    _settings = SettingsModel.fromFirestore(settingsDoc);
    notifyListeners();
  }

  String getSubjectName(String subjectId) {
    return _subjects[subjectId]?.name ?? '';
  }

  Future<void> addSubject(String uid, String subjectName) async {
    final docRef = await _firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .add({
      'name': subjectName,
      'items': [],
    });
    final newSubject =
        SubjectModel(id: docRef.id, name: subjectName, items: []);
    _subjects[docRef.id] = newSubject;
    notifyListeners();
  }

  Future<void> removeSubject(String uid, String subjectId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('subjects')
          .doc(subjectId)
          .delete();
      _subjects.remove(subjectId);
      notifyListeners();
    } catch (e) {
      print('Error removing subject: $e');
    }
  }

  void updateTimetableCell(int day, int period, String subjectId) {
    if (_timetable != null &&
        day >= 0 &&
        day < 7 &&
        period >= 0 &&
        period < (_settings?.period ?? 4)) {
      while (_timetable!.days[day].length <= period) {
        _timetable!.days[day].add('');
      }
      _timetable!.days[day][period] = subjectId;
      notifyListeners();
    }
  }

  Future<void> saveTimetable(String uid) async {
    if (_timetable != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('timetables')
          .doc(_timetable!.id)
          .set(_timetable!.toMap());
    }
  }

  String? getSubjectIdForCell(int day, int period) {
    if (_timetable == null ||
        day < 0 ||
        day >= 7 ||
        period < 0 ||
        period >= (_settings?.period ?? 4)) {
      return null;
    }
    if (period >= _timetable!.days[day].length) {
      return ''; // 空の文字列を返す（科目が設定されていない場合）
    }
    return _timetable!.days[day][period];
  }

  Future<void> addItem(String uid, String subjectId, String itemName) async {
    final subjectRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId);
    await subjectRef.update({
      'items': FieldValue.arrayUnion([itemName])
    });
    _subjects[subjectId]?.items.add(itemName);
    notifyListeners();
  }

  Future<void> removeItem(String uid, String subjectId, String itemName) async {
    final subjectRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId);
    await subjectRef.update({
      'items': FieldValue.arrayRemove([itemName])
    });
    _subjects[subjectId]?.items.remove(itemName);
    notifyListeners();
  }

  Future<void> loadMemo(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    _memo = userDoc.data()?['memo'] ?? '';
    notifyListeners();
  }

  Future<void> saveMemo(String uid, String memo) async {
    await _firestore.collection('users').doc(uid).update({'memo': memo});
    _memo = memo;
    notifyListeners();
  }

  Future<List<String>> fetchTimetableForDay(int day, String uid) async {
    if (uid.isEmpty) return [];

    try {
      var timetableSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('timetables')
          .limit(1) // 最新の時間割を取得
          .get();

      if (timetableSnapshot.docs.isEmpty) return [];

      var timetableData = timetableSnapshot.docs.first.data();
      var timetable = TimetableModel.fromMap(
          timetableSnapshot.docs.first.id, timetableData);

      // dayは1（月曜）から7（日曜）の範囲なので、0から6の範囲に変換
      int dayIndex = day - 1;
      if (dayIndex < 0 || dayIndex >= 7) return [];

      return timetable.days[dayIndex];
    } catch (e) {
      print('Error fetching timetable: $e');
      return [];
    }
  }

  Future<List<SubjectModel>> fetchSubjectsForToday(String uid) async {
    if (uid.isEmpty) return [];

    try {
      // 現在の曜日を取得（1: 月曜日, 7: 日曜日）
      int today = DateTime.now().weekday;

      // 曜日に対応する subjectId のリストを取得
      List<String> subjectIds = await fetchTimetableForDay(today, uid);
      if (subjectIds.isEmpty) return [];

      // subjectId に対応する科目データを取得
      var subjectsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('subjects')
          .where(FieldPath.documentId, whereIn: subjectIds)
          .get();

      return subjectsSnapshot.docs
          .map((doc) => SubjectModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching subjects for today: $e');
      return [];
    }
  }

  Future<void> addEmptyTimetable(String uid) async {
    try {
      final emptyTimetable = {
        'mon': List.filled(_settings?.period ?? 4, ''),
        'tue': List.filled(_settings?.period ?? 4, ''),
        'wed': List.filled(_settings?.period ?? 4, ''),
        'thu': List.filled(_settings?.period ?? 4, ''),
        'fri': List.filled(_settings?.period ?? 4, ''),
        'sat': List.filled(_settings?.period ?? 4, ''),
        'sun': List.filled(_settings?.period ?? 4, ''),
      };
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('timetables')
          .add(emptyTimetable);
    } catch (e) {
      print('Error adding empty timetable: $e');
    }
  }
}
