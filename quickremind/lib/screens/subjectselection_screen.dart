import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';
import '../controller/subject_controller.dart';
import '../screens/itemlist_screen.dart';
import '../widgets/add_form_widget.dart';
import '../utils/dialog_utils.dart';

// 教科を選択する画面。
class SubjectSelectionScreen extends StatefulWidget {
  final String uid; // ユーザーID
  final int day; // 曜日
  final int period; // 時間帯
  final String? selectedSubjectId; // 選択された教科ID

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
  final TextEditingController _subjectNameController =
      TextEditingController(); // 教科名入力用コントローラー
  String? _selectedSubjectId; // 選択された教科ID

  @override
  void initState() {
    super.initState();
    _selectedSubjectId = widget.selectedSubjectId; // 初期選択を設定
  }

  @override
  void dispose() {
    _subjectNameController.dispose(); // コントローラーの解放
    super.dispose();
  }

  // 教科変更処理
  void _handleSubjectChange(String value, SubjectController subjectController,
      TimetableController timetableController) async {
    await timetableController.updateCell(
      widget.uid,
      widget.day,
      widget.period,
      value, // 教科を更新
    );
    Navigator.pop(context); // 画面を閉じる
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimetableController, SubjectController>(
      // 2つのコントローラーを監視
      builder: (context, timetableController, subjectController, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('教科選択')), // 教科選択画面のタイトル
          body: Column(
            children: [
              ItemAddForm(
                controller: _subjectNameController,
                hintText: '新しい教科名',
                onSubmit: () {
                  if (_subjectNameController.text.isNotEmpty) {
                    subjectController.addSubject(
                        widget.uid, _subjectNameController.text); // 教科を追加
                    _subjectNameController.clear(); // 入力フィールドをクリア
                  }
                },
              ),
              Expanded(
                child: ListView(
                  children: subjectController.subjects.values.map((subject) {
                    return RadioListTile<String>(
                        title: Text(subject.name), // 教科名を表示
                        value: subject.id,
                        groupValue: _selectedSubjectId, // 選択された教科ID
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSubjectId = value; // 選択された教科IDを更新
                            });
                            _handleSubjectChange(value, subjectController,
                                timetableController); // 教科変更処理を呼び出す
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
                                    title: "教科を削除", // 削除確認ダイアログ
                                    message: "「${subject.name}」を削除しますか？",
                                  );
                                  if (mounted && shouldDelete) {
                                    subjectController.removeSubject(
                                        widget.uid, subject.id); // 教科を削除
                                  }
                                },
                                icon: const Icon(Icons.delete)), // 削除ボタン
                            IconButton(
                              icon: const Icon(
                                  Icons.arrow_forward_ios), // 次の画面へ遷移するボタン
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
