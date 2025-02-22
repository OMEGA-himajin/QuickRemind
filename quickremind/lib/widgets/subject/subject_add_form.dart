import 'package:flutter/material.dart';

class SubjectAddForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const SubjectAddForm({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '新しい教科名',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }
}
