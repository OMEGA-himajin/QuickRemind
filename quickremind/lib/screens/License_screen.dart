import 'package:flutter/material.dart';

// アプリのライセンス情報を表示。
class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LicensePage(
        applicationName: 'QuickRemind', // アプリ名
        applicationVersion: '0.1.0', // アプリバージョン
        applicationLegalese: 'Created by ASKSTEM', // 制作者情報
      ),
    );
  }
}
