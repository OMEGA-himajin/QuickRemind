import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateTileWidget extends StatelessWidget {
  final DateTime date;

  const DateTileWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja');

    // YYYY/MM/DD (DDD) の形式でフォーマット
    String formattedDate = DateFormat('yyyy/MM/dd (EEE)', 'ja').format(date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 両端の余白
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.blue[100], // 背景色
        borderRadius: BorderRadius.circular(12.0), // 角丸
      ),
      alignment: Alignment.center, // 中央揃え
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontSize: 40,
          // fontWeight: FontWeight.bold, // 太字
        ),
      ),
    );
  }
}
