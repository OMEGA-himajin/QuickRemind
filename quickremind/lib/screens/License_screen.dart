import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LicensePage(
        applicationName: 'QuickRemind',
        applicationVersion: '0.1.0',
        applicationLegalese: 'Created by ASKSTEM',
      ),
    );
  }
}
