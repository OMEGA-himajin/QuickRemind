import 'package:flutter/material.dart';

class ItemAddForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final String hintText;

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
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
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
