import 'package:flutter/material.dart';

class SwipeInstructions extends StatelessWidget {
  const SwipeInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.swipe, size: 20),
          const SizedBox(width: 8),
          Text(
            'スワイプして確認',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
