import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/settings_model.dart';
import 'base_repository.dart';

class SettingsRepository extends BaseRepository {
  Future<SettingsModel> fetchSettings(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return SettingsModel.fromFirestore(doc);
    }
    return SettingsModel(showSat: false, showSun: false, period: 6);
  }

  Future<void> saveSettings(String uid, SettingsModel settings) async {
    await firestore
        .collection('users')
        .doc(uid)
        .set(settings.toJson(), SetOptions(merge: true));
  }
}
