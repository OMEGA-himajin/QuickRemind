import 'package:flutter/material.dart';

class TimetableGrid extends StatelessWidget {
  final List<String> days;
  final int periods;
  final bool showSat;
  final bool showSun;
  final List<List<String>> timetable;
  final Function(int, int) onCellTap;

  const TimetableGrid({
    Key? key,
    required this.days,
    required this.periods,
    required this.showSat,
    required this.showSun,
    required this.timetable,
    required this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final dayCount = 5 + (showSat ? 1 : 0) + (showSun ? 1 : 0);
        final cellWidth = (constraints.maxWidth - 40) / (dayCount + 1);
        final cellHeight = (constraints.maxHeight - 20) / (periods + 1);

        return Table(
          border: TableBorder.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
          columnWidths: {
            0: const FixedColumnWidth(40),
            for (int i = 1; i <= dayCount; i++) i: FixedColumnWidth(cellWidth),
          },
          children: [
            _buildHeaderRow(theme, cellHeight),
            for (int i = 0; i < periods; i++)
              _buildTimeRow(i, theme, cellHeight),
          ],
        );
      },
    );
  }

  TableRow _buildHeaderRow(ThemeData theme, double height) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
      ),
      children: [
        _buildHeaderCell('', theme, height),
        for (int i = 0; i < days.length; i++)
          if ((i < 5) || (i == 5 && showSat) || (i == 6 && showSun))
            _buildHeaderCell(days[i], theme, height),
      ],
    );
  }

  TableRow _buildTimeRow(int period, ThemeData theme, double height) {
    return TableRow(
      children: [
        _buildHeaderCell('${period + 1}', theme, height),
        for (int day = 0; day < days.length; day++)
          if ((day < 5) || (day == 5 && showSat) || (day == 6 && showSun))
            _buildTimetableCell(day, period, theme, height),
      ],
    );
  }

  Widget _buildHeaderCell(String text, ThemeData theme, double height) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: height,
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTimetableCell(
      int day, int period, ThemeData theme, double height) {
    String cellText = '';
    if (day < timetable.length && period < timetable[day].length) {
      cellText = timetable[day][period];
    }

    return InkWell(
      onTap: () => onCellTap(day, period),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: height,
        child: Center(
          child: Text(
            cellText,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
