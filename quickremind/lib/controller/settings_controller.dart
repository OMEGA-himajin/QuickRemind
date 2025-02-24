import 'package:flutter/material.dart';
import 'package:quickremind/model/settings_model.dart';
import 'package:quickremind/repository/settings_repository.dart';

// アプリケーション設定を管理するコントローラー
class SettingsController extends ChangeNotifier {
  final SettingsRepository _repository;
  SettingsModel? _settings;

  SettingsController({required SettingsRepository repository})
      : _repository = repository;

  // 現在の設定を取得
  SettingsModel? get settings => _settings;

  // 設定を読み込む
  Future<void> loadSettings(String uid) async {
    _settings = await _repository.fetchSettings(uid);
    notifyListeners();
  }

  // 設定を保存
  Future<void> saveSettings(String uid) async {
    await _repository.saveSettings(uid, _settings!);
  }

  // 土曜日を表示するかどうかを更新
  void updateShowSat(bool value) {
    _settings = SettingsModel(
        showSat: value, showSun: _settings!.showSun, period: _settings!.period);
    notifyListeners();
  }

  // 日曜日を表示するかどうかを更新
  void updateShowSun(bool value) {
    _settings = SettingsModel(
        showSat: _settings!.showSat, showSun: value, period: _settings!.period);
    notifyListeners();
  }

  // 時限数を更新
  void updatePeriod(int value) {
    if (value < 4 || value > 10) return; // 4〜10 以外の値は無視
    _settings = SettingsModel(
        showSat: _settings!.showSat,
        showSun: _settings!.showSun,
        period: value);
    notifyListeners();
  }
}
