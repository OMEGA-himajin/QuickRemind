import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../controller/auth_controller.dart';
import '../controller/timetable_controller.dart';
import '../model/user_model.dart';
import '../repository/timetable_repository.dart';

// ユーザーのログインまたはサインアップを処理。
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // 認証コントローラーのインスタンスを作成
  final AuthController _authController = AuthController();
  // 入力フィールドのコントローラーを作成
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignUp = true; // サインアップかどうかのフラグ
  String _errorMessage = ''; // エラーメッセージを保持

  // フォームの切り替え
  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp; // サインアップとログインを切り替え
    });
  }

  bool _isFirstLaunch = false; // 初回起動かどうかのフラグ

  @override
  void initState() {
    super.initState();
    _checkUserStatus(); // ユーザーの状態を確認
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
          MaterialPageRoute(builder: (context) => const App()),
        );
      }
    }
  }

  // 認証処理
  Future<void> _authenticate(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (_isSignUp) {
      String confirmPassword = _confirmPasswordController.text.trim();
      if (password != confirmPassword) {
        setState(() {
          _errorMessage = "パスワードが一致しません"; // パスワード不一致エラー
        });
        return;
      }
    }

    UserModel? user;
    if (_isSignUp) {
      user = await authController.signUp(email, password); // サインアップ処理
    } else {
      user = await authController.signIn(email, password); // ログイン処理
    }

    if (user != null) {
      initDatabase(user.uid); // データベースを初期化
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const App(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "認証に失敗しました"; // 認証失敗エラー
      });
    }
  }

  // 匿名ログイン処理
  Future<void> _signInAnonymously(AuthController authController) async {
    UserModel? user = await authController.signInAnonymously();
    if (user != null) {
      initDatabase(user.uid); // データベースを初期化
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const App(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "匿名ログインに失敗しました"; // 匿名ログイン失敗エラー
      });
    }
  }

  // データベースを初期化する
  void initDatabase(String uid) {
    final timetableRepository = TimetableRepository();
    final timetableController =
        TimetableController(repository: timetableRepository);

    // DBに時間割の雛形を追加
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
                    onPressed: () => _authenticate(authController), // 認証ボタン
                    child: Text(_isSignUp ? "アカウント作成" : "ログイン"),
                  ),
                  TextButton(
                    onPressed: () =>
                        _signInAnonymously(authController), // ゲストログインボタン
                    child: const Text("ゲストで続行"),
                  ),
                  TextButton(
                    onPressed: _toggleForm, // フォーム切り替えボタン
                    child: Text(_isSignUp ? "既に登録済みの方" : "新規作成"),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red), // エラーメッセージ表示
                    ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(), // ロード中表示
            ),
    );
  }
}
