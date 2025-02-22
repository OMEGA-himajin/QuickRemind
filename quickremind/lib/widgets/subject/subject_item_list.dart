import 'package:flutter/material.dart';

class SubjectItemList extends StatelessWidget {
  final List<String> items;

  const SubjectItemList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            leading: const Icon(Icons.check_box_outline_blank),
          );
        },
      ),
    );
  }
}
