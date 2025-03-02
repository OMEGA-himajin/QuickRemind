import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/subject_controller.dart';
import '../widgets/item_add_form.dart';
import '../utils/dialog_utils.dart';

class ItemListScreen extends StatefulWidget {
  final String uid;
  final String subjectId;
  final String subjectName;

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
  final TextEditingController _itemNameController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectController>(
      builder: (context, subjectController, child) {
        final subject = subjectController.subjects[widget.subjectId];
        final items = subject?.items ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text("${widget.subjectName}の持ち物"),
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
                      _itemNameController.text,
                    );
                    _itemNameController.clear();
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final shouldDelete =
                              await DialogUtils.showConfirmDialog(
                            context: context,
                            title: "アイテムの削除",
                            message: "${items[index]}を削除してもよろしいですか？",
                          );
                          if (shouldDelete) {
                            subjectController.removeItem(
                              widget.uid,
                              widget.subjectId,
                              items[index],
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
