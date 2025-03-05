import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';
import '../controller/subject_controller.dart';
import '../screens/itemlist_screen.dart';
import '../widgets/add_form_widget.dart';
import '../utils/dialog_utils.dart';

class SubjectSelectionScreen extends StatefulWidget {
  final String uid;
  final int day;
  final int period;
  final String? selectedSubjectId;

  const SubjectSelectionScreen({
    super.key,
    required this.uid,
    required this.day,
    required this.period,
    this.selectedSubjectId,
  });

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  final TextEditingController _subjectNameController = TextEditingController();
  String? _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _selectedSubjectId = widget.selectedSubjectId;
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    super.dispose();
  }

  void _handleSubjectChange(String value, SubjectController subjectController,
      TimetableController timetableController) async {
    await timetableController.updateCell(
      widget.uid,
      widget.day,
      widget.period,
      value,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimetableController, SubjectController>(
      builder: (context, timetableController, subjectController, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('教科選択')),
          body: Column(
            children: [
              ItemAddForm(
                controller: _subjectNameController,
                hintText: '新しい教科名',
                onSubmit: () {
                  if (_subjectNameController.text.isNotEmpty) {
                    subjectController.addSubject(
                        widget.uid, _subjectNameController.text);
                    _subjectNameController.clear();
                  }
                },
              ),
              Expanded(
                child: ListView(
                  children: subjectController.subjects.values.map((subject) {
                    return RadioListTile<String>(
                        title: Text(subject.name),
                        value: subject.id,
                        groupValue: _selectedSubjectId,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSubjectId = value;
                            });
                            _handleSubjectChange(
                                value, subjectController, timetableController);
                          }
                        },
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  final shouldDelete =
                                      await DialogUtils.showConfirmDialog(
                                    context: context,
                                    title: "教科を削除",
                                    message: "「${subject.name}」を削除しますか？",
                                  );
                                  if (mounted && shouldDelete) {
                                    subjectController.removeSubject(
                                        widget.uid, subject.id);
                                  }
                                },
                                icon: const Icon(Icons.delete)),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemListScreen(
                                      uid: widget.uid,
                                      subjectId: subject.id,
                                      subjectName: subject.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ));
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
