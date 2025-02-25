import 'package:cloud_firestore/cloud_firestore.dart';

// リポジトリの基底クラス
// Firestoreインスタンスを提供
abstract class BaseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}
