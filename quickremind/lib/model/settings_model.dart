class SettingsModel {
  bool showSat;
  bool showSun;
  int _period;

  SettingsModel({
    required this.showSat,
    required this.showSun,
    required int period,
  }) : _period = _validatePeriod(period);

  int get period => _period;

  set period(int value) {
    _period = _validatePeriod(value);
  }

  static int _validatePeriod(int value) {
    if (value < 4 || value > 10) {
      throw ArgumentError('Period must be between 4 and 10.');
    }
    return value;
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      showSat: map['showSat'] ?? false,
      showSun: map['showSun'] ?? false,
      period: map['period'] ?? 6, // デフォルト値を6に設定
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showSat': showSat,
      'showSun': showSun,
      'period': _period,
    };
  }
}
