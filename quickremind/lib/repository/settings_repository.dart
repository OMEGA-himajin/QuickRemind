import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/settings_model.dart';
import 'base_repository.dart';

// アプリケーション設定のFirestore操作を管理するリポジトリ
class SettingsRepository extends BaseRepository {
  // 設定を取得
  Future<SettingsModel> fetchSettings(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return SettingsModel.fromFirestore(doc);
    }
    return SettingsModel(showSat: false, showSun: false, period: 6);
  }

  // 設定を保存
  Future<void> saveSettings(String uid, SettingsModel settings) async {
    await firestore
        .collection('users')
        .doc(uid)
        .set(settings.toJson(), SetOptions(merge: true));
  }
}
