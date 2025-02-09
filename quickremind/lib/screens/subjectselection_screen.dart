import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/screens/itemlist_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  final String uid;
  final int day;
  final int period;
  final String? selectedSubjectId;

  const SubjectSelectionScreen({
    Key? key,
    required this.uid,
    required this.day,
    required this.period,
    this.selectedSubjectId,
  }) : super(key: key);

  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableController>(
      builder: (context, timetableController, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('教科選択')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subjectNameController,
                        decoration: const InputDecoration(
                          hintText: '新しい教科名',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_subjectNameController.text.isNotEmpty) {
                          timetableController.addSubject(
                              widget.uid, _subjectNameController.text);
                          _subjectNameController.clear();
                        }
                      },
                      child: const Text('追加'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: timetableController.subjects.values.map((subject) {
                    return RadioListTile<String>(
                        title: Text(subject.name),
                        value: subject.id,
                        groupValue: _selectedSubjectId,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSubjectId = value;
                            });
                            timetableController.updateTimetableCell(
                                widget.day, widget.period, value);
                            timetableController.saveTimetable(widget.uid);
                            Navigator.pop(context);
                          }
                        },
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("教科を削除"),
                                        content:
                                            Text("「${subject.name}」を削除しますか？"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("キャンセル"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              timetableController.removeSubject(
                                                  widget.uid, subject.id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("削除",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
