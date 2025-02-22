import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}
