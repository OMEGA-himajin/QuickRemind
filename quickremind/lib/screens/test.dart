import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/timetable_grid.dart';
import '../controller/timetable_controller.dart';
import '../model/user_model.dart';

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TimetableController>(context);
    final user = Provider.of<UserModel>(context);

    // ユーザーが設定されていない場合は設定する
    if (controller.user == null) {
      controller.setUser(user);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('時間割'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TimetableGrid(
            days: ['月', '火', '水', '木', '金', '土', '日'],
            periods: controller.settings.period,
            showSat: controller.settings.showSat,
            showSun: controller.settings.showSun,
            timetable: controller.timetable?.classes ??
                List.generate(7, (_) => List.filled(10, '')),
            onCellTap: (day, period) {
              print('Tapped day: $day, period: $period');
              // ここでセルをタップした時の処理を実装
            },
          ),
        ),
      ),
    );
  }
}
