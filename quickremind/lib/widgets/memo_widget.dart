import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/memo_controller.dart';

// メモを表示・編集するウィジェット
class MemoWidget extends StatefulWidget {
  final String uid;

  const MemoWidget({
    super.key,
    required this.uid,
  });

  @override
  State<MemoWidget> createState() => _MemoWidgetState();
}

class _MemoWidgetState extends State<MemoWidget> {
  final TextEditingController _textController =
      TextEditingController(); // テキストコントローラー
  bool _isLoading = true; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    _loadMemo(); // メモをロード
  }

  // メモを非同期でロードする
  Future<void> _loadMemo() async {
    final memoController = context.read<MemoController>();
    await memoController.loadMemo(widget.uid); // メモを取得
    setState(() {
      _textController.text = memoController.memoText; // テキストフィールドにメモを設定
      _isLoading = false; // ロード完了
    });
  }

  // メモを保存する
  void _saveMemo(String value) {
    context.read<MemoController>().saveMemo(widget.uid, value); // メモを保存
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator()) // ローディング中表示
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
                    controller: _textController, // コントローラーを設定
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
