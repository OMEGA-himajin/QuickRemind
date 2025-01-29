import 'package:flutter/material.dart';
import 'package:quickremind/app.dart';
import 'package:quickremind/controller/auth_controller.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthController _authController = AuthController();
  bool _isFirstLaunch = false; // 初回起動かどうかのフラグ

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // ユーザー情報をチェックして、初回起動かどうかを確認する
  Future<void> _checkUserStatus() async {
    bool isUserLoggedIn = await _authController.isUserLoggedIn();

    if (!isUserLoggedIn) {
      // 初回起動の場合、ボタンを表示
      setState(() {
        _isFirstLaunch = true;
      });
    } else {
      // 初回起動以外の場合は自動的にホーム画面に遷移
      _navigateToHomeScreen();
    }
  }

  // 匿名サインイン後にホーム画面に遷移
  Future<void> _signInAnonymouslyAndNavigate() async {
    await _authController.signInAnonymously();
    _navigateToHomeScreen();
  }

  // ホーム画面に遷移する
  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => (App())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isFirstLaunch
            ? ElevatedButton(
                onPressed: _signInAnonymouslyAndNavigate,
                child: Text('始める'),
              )
            : CircularProgressIndicator(), // 初回起動以外は処理中のインジケーターを表示
      ),
    );
  }
}
