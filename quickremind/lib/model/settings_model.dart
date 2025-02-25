import 'package:cloud_firestore/cloud_firestore.dart';

// アプリケーション設定を管理するモデル
class SettingsModel {
  final bool showSat;
  final bool showSun;
  final int period;

  SettingsModel({
    required this.showSat,
    required this.showSun,
    required this.period,
  });

  // Firestoreから取得したデータをオブジェクトに変換
  // 範囲外のperiodは4〜10の範囲に補正される
  factory SettingsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    int period = data['Period'] ?? 6;

    // 4〜10 の範囲に補正
    if (period < 4) period = 4;
    if (period > 10) period = 10;

    return SettingsModel(
      showSat: data['showSat'] ?? false,
      showSun: data['showSun'] ?? false,
      period: period,
    );
  }

  // Firestoreに保存するためのJSON変換
  Map<String, dynamic> toJson() {
    return {
      'showSat': showSat,
      'showSun': showSun,
      'Period': period,
    };
  }
}
