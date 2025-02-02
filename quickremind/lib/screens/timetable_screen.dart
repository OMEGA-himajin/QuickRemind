import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/widgets/timetable_grid.dart';
import 'package:quickremind/screens/subjectselection_screen.dart';

class TimetableScreen extends StatefulWidget {
  final String uid;

  const TimetableScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
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
    await timetableController.loadTimetable(widget.uid);
    await timetableController.loadSubjects(widget.uid);
    await timetableController.loadSettings(widget.uid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableController>(
      builder: (context, timetableController, child) {
        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final timetable = timetableController.timetable;
        final settings = timetableController.settings;

        if (timetable == null || settings == null) {
          return const Scaffold(
            body: Center(child: Text("時間割の読み込みに失敗しました。")),
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
          timetable.sun
        ];

        return Scaffold(
          appBar: AppBar(title: const Text("時間割")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimetableGrid(
              days: days,
              periods: settings.period,
              showSat: settings.showSat,
              showSun: settings.showSun,
              timetable: timetableData
                  .map((day) => day
                      .map((subjectId) =>
                          timetableController.getSubjectName(subjectId))
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
                      selectedSubjectId:
                          timetableController.getSubjectIdForCell(day, period),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
