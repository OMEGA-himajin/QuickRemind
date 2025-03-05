import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/settings_controller.dart';

// アプリの設定を管理。
class SettingsScreen extends StatefulWidget {
  final String uid; // FirestoreのユーザーID

  const SettingsScreen({super.key, required this.uid});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    _loadSettings(); // 設定をロード
  }

  // 設定を非同期でロードする
  Future<void> _loadSettings() async {
    final settingsController = context.read<SettingsController>();
    await settingsController.loadSettings(widget.uid); // 設定を取得
    setState(() {
      _isLoading = false; // ロード完了後、ローディング終了
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsController =
        context.watch<SettingsController>(); // 設定コントローラーを監視

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // ロード中表示
      );
    }

    final settings = settingsController.settings; // 設定を取得
    if (settings == null) {
      return const Scaffold(
        body: Center(child: Text("設定の読み込みに失敗しました。")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("設定")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("土曜表示"), // 土曜表示のスイッチ
            value: settings.showSat,
            onChanged: (value) {
              settingsController.updateShowSat(value); // 土曜表示の更新
              settingsController.saveSettings(widget.uid); // 設定を保存
            },
          ),
          SwitchListTile(
            title: const Text("日曜表示"), // 日曜表示のスイッチ
            value: settings.showSun,
            onChanged: (value) {
              settingsController.updateShowSun(value); // 日曜表示の更新
              settingsController.saveSettings(widget.uid); // 設定を保存
            },
          ),
          ListTile(
            title: const Text("表示授業時間"), // 授業時間の設定
            subtitle: Text(settings.period.toString()), // 現在の授業時間を表示
            trailing: DropdownButton<int>(
              value: settings.period, // 現在の授業時間を選択
              items: List.generate(7, (index) => index + 4).map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()), // 授業時間の選択肢
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  settingsController.updatePeriod(value); // 授業時間の更新
                  settingsController.saveSettings(widget.uid); // 設定を保存
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
