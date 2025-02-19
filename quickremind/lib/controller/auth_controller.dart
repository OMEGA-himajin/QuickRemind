import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickremind/model/user_model.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
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

  // 新規登録
  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user != null ? UserModel(uid: user.uid, email: user.email) : null;
    } catch (e) {
      print("Error during sign-up: $e");
      return null;
    }
  }

  // ログイン
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user != null ? UserModel(uid: user.uid, email: user.email) : null;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }
}
