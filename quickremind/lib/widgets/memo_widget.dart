import 'package:flutter/material.dart';
import '../controller/memo_controller.dart';
import 'package:provider/provider.dart';

class MemoWidget extends StatefulWidget {
  final String uid;

  const MemoWidget({
    super.key,
    required this.uid,
  });

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
    final memoController = context.read<MemoController>();
    await memoController.loadMemo(widget.uid);
    setState(() {
      _textController.text = memoController.memoText;
      _isLoading = false;
    });
  }

  void _saveMemo(String value) {
    context.read<MemoController>().saveMemo(widget.uid, value);
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
