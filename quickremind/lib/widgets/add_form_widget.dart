import 'package:flutter/material.dart';

// リスト追加用のフォームウィジェット
class ItemAddForm extends StatelessWidget {
  final TextEditingController controller; // テキストフィールドのコントローラー
  final VoidCallback onSubmit; // 追加ボタンが押されたときのコールバック
  final String hintText; // テキストフィールドのヒントテキスト

  const ItemAddForm({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller, // コントローラーを設定
              decoration: InputDecoration(
                hintText: hintText, // ヒントテキストを設定
                border: const OutlineInputBorder(), // 枠線を設定
              ),
            ),
          ),
          const SizedBox(width: 8), // テキストフィールドとボタンの間隔
          ElevatedButton(
            onPressed: onSubmit, // 追加ボタンのコールバック
            child: const Text('追加'), // ボタンのテキスト
          ),
        ],
      ),
    );
  }
}
