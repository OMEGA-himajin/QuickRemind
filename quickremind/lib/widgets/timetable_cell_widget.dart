import 'package:flutter/material.dart';

class TimetableCell extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double height;
  final bool isHeader;

  const TimetableCell({
    Key? key,
    required this.text,
    required this.onTap,
    required this.height,
    this.isHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: height,
        decoration: BoxDecoration(
          color: isHeader ? theme.colorScheme.secondaryContainer : null,
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isHeader ? FontWeight.bold : null,
              color: isHeader ? theme.colorScheme.onSecondaryContainer : null,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
