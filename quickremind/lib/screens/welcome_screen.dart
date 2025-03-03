import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/app.dart';
import 'package:quickremind/controller/auth_controller.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/model/user_model.dart';
import 'package:quickremind/repository/timetable_repository.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthController _authController = AuthController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignUp = true;
  String _errorMessage = '';

  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

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
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
      }
    }
  }

  Future<void> _authenticate(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (_isSignUp) {
      String confirmPassword = _confirmPasswordController.text.trim();
      if (password != confirmPassword) {
        setState(() {
          _errorMessage = "パスワードが一致しません";
        });
        return;
      }
    }

    UserModel? user;
    if (_isSignUp) {
      user = await authController.signUp(email, password);
    } else {
      user = await authController.signIn(email, password);
    }

    if (user != null) {
      initDatabase(user.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => App(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "認証に失敗しました";
      });
    }
  }

  Future<void> _signInAnonymously(AuthController authController) async {
    UserModel? user = await authController.signInAnonymously();
    if (user != null) {
      initDatabase(user.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => App(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "匿名ログインに失敗しました";
      });
    }
  }

  void initDatabase(String uid) {
    final timetableRepository = TimetableRepository();
    final timetableController =
        TimetableController(repository: timetableRepository);

    // 時間割を追加
    timetableController.addEmptyTimetable(uid);
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      body: _isFirstLaunch
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "メール"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "パスワード"),
                    obscureText: true,
                  ),
                  if (_isSignUp)
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(labelText: "パスワードの確認"),
                      obscureText: true,
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _authenticate(authController),
                    child: Text(_isSignUp ? "アカウント作成" : "ログイン"),
                  ),
                  TextButton(
                    onPressed: () => _signInAnonymously(authController),
                    child: const Text("ゲストで続行"),
                  ),
                  TextButton(
                    onPressed: _toggleForm,
                    child: Text(_isSignUp ? "既に登録済みの方" : "新規作成"),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
