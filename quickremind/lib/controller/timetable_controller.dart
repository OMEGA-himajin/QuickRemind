import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/timetable_model.dart';
import '../model/settings_model.dart';
import '../model/user_model.dart';

class TimetableController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimetableModel? timetable;
  SettingsModel settings = SettingsModel(
    showSat: true,
    showSun: false,
    period: 6,
  );
  bool isLoading = false;
  UserModel? user;

  void setUser(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> loadTimetable(String tableId) async {
    if (user == null) return;
    isLoading = true;
    notifyListeners();

    try {
      // 時間割を取得
      DocumentSnapshot timetableDoc = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('timetables')
          .doc(tableId)
          .get();

      if (timetableDoc.exists) {
        timetable = TimetableModel.fromMap(
            tableId, timetableDoc.data() as Map<String, dynamic>);
      }

      // ユーザー設定を取得
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        settings =
            SettingsModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error loading data: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateTimetable() async {
    if (user == null || timetable == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('timetables')
          .doc(timetable!.id)
          .set(timetable!.toMap());
    } catch (e) {
      print('Error updating timetable: $e');
    }
    notifyListeners();
  }

  Future<void> updateSettings() async {
    if (user == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .set(settings.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating settings: $e');
    }
    notifyListeners();
  }

  void toggleSaturday() {
    settings.showSat = !settings.showSat;
    notifyListeners();
  }

  void toggleSunday() {
    settings.showSun = !settings.showSun;
    notifyListeners();
  }

  void setperiod(int count) {
    if (count >= 4 && count <= 10) {
      settings.period = count;
      notifyListeners();
    }
  }
}
