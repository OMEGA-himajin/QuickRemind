import 'package:flutter/material.dart';

// 時間割のセルを表示するウィジェット
class TimetableCell extends StatelessWidget {
  final String text; // セルに表示するテキスト
  final VoidCallback onTap; // セルがタップされたときのコールバック
  final double height; // セルの高さ
  final bool isHeader; // ヘッダーかどうかのフラグ

  const TimetableCell({
    super.key,
    required this.text,
    required this.onTap,
    required this.height,
    this.isHeader = false, // デフォルトはヘッダーではない
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap, // タップ時のコールバック
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: height, // セルの高さを設定
        decoration: BoxDecoration(
          color: isHeader
              ? theme.colorScheme.secondaryContainer
              : null, // ヘッダーの場合の背景色
        ),
        child: Center(
          child: Text(
            text, // セルに表示するテキスト
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isHeader ? FontWeight.bold : null, // ヘッダーの場合は太字
              color: isHeader
                  ? theme.colorScheme.onSecondaryContainer
                  : null, // ヘッダーの場合のテキスト色
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // テキストが溢れた場合の処理
          ),
        ),
      ),
    );
  }
}
