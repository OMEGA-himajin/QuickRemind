import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/controller/timetable_controller.dart';

class ItemListScreen extends StatefulWidget {
  final String uid;
  final String subjectId;
  final String subjectName;

  const ItemListScreen({
    Key? key,
    required this.uid,
    required this.subjectId,
    required this.subjectName,
  }) : super(key: key);

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
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
    return Consumer<TimetableController>(
      builder: (context, timetableController, child) {
        final subject = timetableController.subjects[widget.subjectId];
        final items = subject?.items ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text("${widget.subjectName}の持ち物"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemNameController,
                        decoration: const InputDecoration(
                          hintText: '新しいアイテム名',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_itemNameController.text.isNotEmpty) {
                          timetableController.addItem(
                            widget.uid,
                            widget.subjectId,
                            _itemNameController.text,
                          );
                          _itemNameController.clear();
                        }
                      },
                      child: const Text('追加'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("アイテムの削除"),
                                content: Text("${items[index]}を削除してもよろしいですか？"),
                                actions: [
                                  TextButton(
                                    child: const Text("キャンセル"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("削除"),
                                    onPressed: () {
                                      timetableController.removeItem(
                                        widget.uid,
                                        widget.subjectId,
                                        items[index],
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
