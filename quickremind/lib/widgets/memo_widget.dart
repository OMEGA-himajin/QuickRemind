import 'package:flutter/material.dart';
import 'package:quickremind/model/memo_model.dart';
import '../controller/memo_controller.dart';

class MemoWidget extends StatefulWidget {
  final MemoController controller;

  const MemoWidget({super.key, required this.controller});

  @override
  _MemoWidgetState createState() => _MemoWidgetState();
}

class _MemoWidgetState extends State<MemoWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemo();
  }

  Future<void> _loadMemo() async {
    MemoModel memo = await widget.controller.fetchMemo();
    setState(() {
      _textController.text = memo.memo;
      _isLoading = false;
    });
  }

  void _saveMemo(String value) {
    widget.controller.saveMemo(value);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator()) // ローディング中
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.blue[100], // 背景色
              borderRadius: BorderRadius.circular(12.0), // 角丸
            ),
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.blue), // 鉛筆アイコン
                const SizedBox(width: 8.0), // アイコンとテキストフィールドの間隔
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // 枠線なし
                      hintText: 'メモを入力...',
                      filled: true,
                      fillColor: Colors.transparent, // 背景透明
                    ),
                    onChanged: _saveMemo, // 入力のたびに保存
                  ),
                ),
              ],
            ),
          );
  }
}
