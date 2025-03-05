import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/subject_controller.dart';
import '../widgets/add_form_widget.dart';
import '../utils/dialog_utils.dart';

// 特定の教科に関連するアイテムのリストを表示。
class ItemListScreen extends StatefulWidget {
  final String uid; // ユーザーID
  final String subjectId; // 教科ID
  final String subjectName; // 教科名

  const ItemListScreen({
    super.key,
    required this.uid,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _itemNameController =
      TextEditingController(); // アイテム名入力用コントローラー

  @override
  void dispose() {
    _itemNameController.dispose(); // コントローラーの解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectController>(
      // SubjectControllerを監視
      builder: (context, subjectController, child) {
        final subject = subjectController.subjects[widget.subjectId]; // 教科を取得
        final items = subject?.items ?? []; // アイテムリストを取得

        return Scaffold(
          appBar: AppBar(
            title: Text("${widget.subjectName}の持ち物"), // 教科名を表示
          ),
          body: Column(
            children: [
              ItemAddForm(
                controller: _itemNameController,
                hintText: '新しいアイテム名',
                onSubmit: () {
                  if (_itemNameController.text.isNotEmpty) {
                    subjectController.addItem(
                      widget.uid,
                      widget.subjectId,
                      _itemNameController.text, // アイテムを追加
                    );
                    _itemNameController.clear(); // 入力フィールドをクリア
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length, // アイテム数を指定
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]), // アイテム名を表示
                      trailing: IconButton(
                        icon: const Icon(Icons.delete), // 削除ボタン
                        onPressed: () async {
                          final shouldDelete =
                              await DialogUtils.showConfirmDialog(
                            context: context,
                            title: "アイテムの削除", // 削除確認ダイアログ
                            message: "${items[index]}を削除してもよろしいですか？",
                          );
                          if (shouldDelete) {
                            subjectController.removeItem(
                              widget.uid,
                              widget.subjectId,
                              items[index], // アイテムを削除
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
