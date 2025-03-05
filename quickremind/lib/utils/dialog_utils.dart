import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title, // ダイアログのタイトル
    required String message, // ダイアログのメッセージ
    String confirmText = '削除', // 確認ボタンのテキスト
    String cancelText = 'キャンセル', // キャンセルボタンのテキスト
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title), // タイトルを設定
        content: Text(message), // メッセージを設定
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // キャンセルボタン
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // 確認ボタン
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false; // 結果がnullの場合はfalseを返す
  }
}
