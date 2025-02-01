import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickremind/model/settings_model.dart';

class SettingsController extends ChangeNotifier {
  SettingsModel? _settings;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SettingsModel? get settings => _settings;

  Future<void> loadSettings(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      _settings = SettingsModel.fromFirestore(doc);
    } else {
      _settings = SettingsModel(showSat: false, showSun: false, period: 6);
      await saveSettings(uid);
    }
    notifyListeners(); // 🔥 データ更新を通知
  }

  Future<void> saveSettings(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(_settings!.toJson(), SetOptions(merge: true));
  }

  void updateShowSat(bool value) {
    _settings = SettingsModel(
        showSat: value, showSun: _settings!.showSun, period: _settings!.period);
    notifyListeners();
  }

  void updateShowSun(bool value) {
    _settings = SettingsModel(
        showSat: _settings!.showSat, showSun: value, period: _settings!.period);
    notifyListeners();
  }

  void updatePeriod(int value) {
    if (value < 4 || value > 10) return; // 4〜10 以外の値は無視
    _settings = SettingsModel(
        showSat: _settings!.showSat,
        showSun: _settings!.showSun,
        period: value);
    notifyListeners();
  }
}
