import 'package:flutter/material.dart';
import 'package:quickremind/model/settings_model.dart';
import 'package:quickremind/repository/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository _repository;
  SettingsModel? _settings;

  SettingsController({required SettingsRepository repository})
      : _repository = repository;

  SettingsModel? get settings => _settings;

  Future<void> loadSettings(String uid) async {
    _settings = await _repository.fetchSettings(uid);
    notifyListeners();
  }

  Future<void> saveSettings(String uid) async {
    await _repository.saveSettings(uid, _settings!);
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
