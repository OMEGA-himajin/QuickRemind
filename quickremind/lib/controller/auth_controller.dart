import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickremind/model/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 匿名でサインイン
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return user != null ? UserModel(uid: user.uid) : null;
    } catch (e) {
      print('Error during sign-in: $e');
      return null;
    }
  }

  // 現在のユーザー情報を取得
  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // ユーザーがログインしているかどうかを確認
  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }
}
