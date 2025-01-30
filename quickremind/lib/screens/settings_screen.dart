import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TimetableController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('土曜日を表示'),
            value: controller.settings.showSat,
            onChanged: (bool value) {
              controller.toggleSaturday();
              controller.updateSettings();
            },
          ),
          SwitchListTile(
            title: Text('日曜日を表示'),
            value: controller.settings.showSun,
            onChanged: (bool value) {
              controller.toggleSunday();
              controller.updateSettings();
            },
          ),
          ListTile(
            title: Text('表示時間数'),
            trailing: DropdownButton<int>(
              value: controller.settings.period,
              items: List.generate(7, (index) => index + 4).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  controller.setperiod(newValue);
                  controller.updateSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
