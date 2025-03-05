import 'package:flutter/material.dart';

// 時間割を表示するグリッドウィジェット
class TimetableGrid extends StatelessWidget {
  final List<String> days; // 曜日のリスト
  final int periods; // 授業時間数
  final bool showSat; // 土曜日を表示するかどうか
  final bool showSun; // 日曜日を表示するかどうか
  final List<List<String>> timetable; // 時間割データ
  final Function(int, int) onCellTap; // セルがタップされたときのコールバック

  const TimetableGrid({
    super.key,
    required this.days,
    required this.periods,
    required this.showSat,
    required this.showSun,
    required this.timetable,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final dayCount = 5 + (showSat ? 1 : 0) + (showSun ? 1 : 0); // 表示する曜日の数
        final cellWidth = (constraints.maxWidth - 40) / (dayCount + 1); // セルの幅
        final cellHeight =
            (constraints.maxHeight - 20) / (periods + 1); // セルの高さ

        return Table(
          border: TableBorder.all(
            color: theme.colorScheme.outlineVariant, // テーブルの枠線色
            width: 1,
          ),
          columnWidths: {
            0: const FixedColumnWidth(40), // 時間列の幅
            for (int i = 1; i <= dayCount; i++)
              i: FixedColumnWidth(cellWidth), // 曜日列の幅
          },
          children: [
            _buildHeaderRow(theme, cellHeight), // ヘッダー行を構築
            for (int i = 0; i < periods; i++)
              _buildTimeRow(i, theme, cellHeight), // 各時間行を構築
          ],
        );
      },
    );
  }

  // ヘッダー行を構築する
  TableRow _buildHeaderRow(ThemeData theme, double height) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer, // ヘッダーの背景色
      ),
      children: [
        _buildHeaderCell('', theme, height), // 空のセル
        for (int i = 0; i < days.length; i++)
          if ((i < 5) || (i == 5 && showSat) || (i == 6 && showSun))
            _buildHeaderCell(days[i], theme, height), // 曜日セルを構築
      ],
    );
  }

  // 各時間行を構築する
  TableRow _buildTimeRow(int period, ThemeData theme, double height) {
    return TableRow(
      children: [
        _buildHeaderCell('${period + 1}', theme, height), // 時間セルを構築
        for (int day = 0; day < days.length; day++)
          if ((day < 5) || (day == 5 && showSat) || (day == 6 && showSun))
            _buildTimetableCell(day, period, theme, height), // 時間割セルを構築
      ],
    );
  }

  // ヘッダーセルを構築する
  Widget _buildHeaderCell(String text, ThemeData theme, double height) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: height,
      child: Center(
        child: Text(
          text, // セルに表示するテキスト
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold, // 太字
            color: theme.colorScheme.onSecondaryContainer, // テキスト色
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // 時間割セルを構築する
  Widget _buildTimetableCell(
      int day, int period, ThemeData theme, double height) {
    String cellText = '';
    if (day < timetable.length && period < timetable[day].length) {
      cellText = timetable[day][period]; // セルに表示するテキストを取得
    }

    return InkWell(
      onTap: () => onCellTap(day, period), // セルがタップされたときの処理
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: height,
        child: Center(
          child: Text(
            cellText, // セルに表示するテキスト
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // テキストが溢れた場合の処理
          ),
        ),
      ),
    );
  }
}
