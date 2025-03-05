import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';
import '../controller/settings_controller.dart';
import '../controller/subject_controller.dart';
import '../widgets/timetable_grid_widget.dart';
import '../screens/subjectselection_screen.dart';

// ユーザーの時間割を表示。
class TimetableScreen extends StatefulWidget {
  final String uid;

  const TimetableScreen({super.key, required this.uid});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _isLoading = true; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    _loadData(); // データをロード
  }

  // データを非同期でロードする
  Future<void> _loadData() async {
    final timetableController = context.read<TimetableController>();
    final subjectController = context.read<SubjectController>();
    final settingsController = context.read<SettingsController>();

    await Future.wait([
      timetableController.loadTimetable(widget.uid), // 時間割を取得
      subjectController.loadSubjects(widget.uid), // 教科を取得
      settingsController.loadSettings(widget.uid), // 設定を取得
    ]);

    setState(() {
      _isLoading = false; // ロード完了後、ローディング終了
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TimetableController, SubjectController,
        SettingsController>(
      // 3つのコントローラーを監視
      builder: (context, timetableController, subjectController,
          settingsController, child) {
        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // ロード中表示
          );
        }

        final timetable = timetableController.timetable; // 時間割を取得
        final settings = settingsController.settings; // 設定を取得

        if (timetable == null || settings == null) {
          return const Scaffold(
            body: Center(child: Text("データの読み込みに失敗しました。")),
          );
        }

        final days = ['月', '火', '水', '木', '金', '土', '日']; // 曜日リスト
        final timetableData = [
          timetable.mon,
          timetable.tue,
          timetable.wed,
          timetable.thu,
          timetable.fri,
          timetable.sat,
          timetable.sun,
        ];

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TimetableGrid(
                days: days, // 曜日を渡す
                periods: settings.period, // 授業時間を渡す
                showSat: settings.showSat, // 土曜表示設定を渡す
                showSun: settings.showSun, // 日曜表示設定を渡す
                timetable: timetableData
                    .map((day) => day
                        .map((subjectId) => subjectController
                            .getSubjectName(subjectId)) // 教科名を取得
                        .toList())
                    .toList(),
                onCellTap: (day, period) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectSelectionScreen(
                        uid: widget.uid,
                        day: day,
                        period: period,
                        selectedSubjectId: timetableController
                            .getSubjectIdForCell(day, period), // 選択された教科IDを渡す
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
