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

  TimetableModel? get timetable => _timetable;
  Map<String, SubjectModel> get subjects => _subjects;
  SettingsModel? get settings => _settings;

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
      notifyListeners();
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

  void updateTimetableCell(int day, int period, String subjectId) {
    if (_timetable != null) {
      switch (day) {
        case 0:
          _timetable!.mon[period] = subjectId;
          break;
        case 1:
          _timetable!.tue[period] = subjectId;
          break;
        case 2:
          _timetable!.wed[period] = subjectId;
          break;
        case 3:
          _timetable!.thu[period] = subjectId;
          break;
        case 4:
          _timetable!.fri[period] = subjectId;
          break;
        case 5:
          _timetable!.sat[period] = subjectId;
          break;
        case 6:
          _timetable!.sun[period] = subjectId;
          break;
      }
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
    if (_timetable == null) return null;
    switch (day) {
      case 0:
        return _timetable!.mon[period];
      case 1:
        return _timetable!.tue[period];
      case 2:
        return _timetable!.wed[period];
      case 3:
        return _timetable!.thu[period];
      case 4:
        return _timetable!.fri[period];
      case 5:
        return _timetable!.sat[period];
      case 6:
        return _timetable!.sun[period];
      default:
        return null;
    }
  }
}
