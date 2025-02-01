import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/settings_controller.dart';

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
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsController = context.read<SettingsController>();
    await settingsController.loadSettings(widget.uid);
    setState(() {
      _isLoading = false; // ロード完了後、ローディング終了
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // 🔄 ロード中表示
      );
    }

    final settings = settingsController.settings;
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
            title: const Text("土曜表示"),
            value: settings.showSat,
            onChanged: (value) {
              settingsController.updateShowSat(value);
              settingsController.saveSettings(widget.uid);
            },
          ),
          SwitchListTile(
            title: const Text("日曜表示"),
            value: settings.showSun,
            onChanged: (value) {
              settingsController.updateShowSun(value);
              settingsController.saveSettings(widget.uid);
            },
          ),
          ListTile(
            title: const Text("表示授業時間"),
            subtitle: Text(settings.period.toString()),
            trailing: DropdownButton<int>(
              value: settings.period,
              items: List.generate(7, (index) => index + 4).map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  settingsController.updatePeriod(value);
                  settingsController.saveSettings(widget.uid);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
