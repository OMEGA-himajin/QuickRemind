import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/controller/settings_controller.dart';
import 'package:quickremind/widgets/timetable_grid_widget.dart';
import 'package:quickremind/screens/subjectselection_screen.dart';
import 'package:quickremind/controller/subject_controller.dart';

class TimetableScreen extends StatefulWidget {
  final String uid;

  const TimetableScreen({super.key, required this.uid});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final timetableController = context.read<TimetableController>();
    final subjectController = context.read<SubjectController>();
    final settingsController = context.read<SettingsController>();

    await Future.wait([
      timetableController.loadTimetable(widget.uid),
      subjectController.loadSubjects(widget.uid),
      settingsController.loadSettings(widget.uid),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TimetableController, SubjectController,
        SettingsController>(
      builder: (context, timetableController, subjectController,
          settingsController, child) {
        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final timetable = timetableController.timetable;
        final settings = settingsController.settings;

        if (timetable == null || settings == null) {
          return const Scaffold(
            body: Center(child: Text("データの読み込みに失敗しました。")),
          );
        }

        final days = ['月', '火', '水', '木', '金', '土', '日'];
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
                days: days,
                periods: settings.period,
                showSat: settings.showSat,
                showSun: settings.showSun,
                timetable: timetableData
                    .map((day) => day
                        .map((subjectId) =>
                            subjectController.getSubjectName(subjectId))
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
                            .getSubjectIdForCell(day, period),
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
