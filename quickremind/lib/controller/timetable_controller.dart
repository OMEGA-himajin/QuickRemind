import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    }
    notifyListeners();
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
}
