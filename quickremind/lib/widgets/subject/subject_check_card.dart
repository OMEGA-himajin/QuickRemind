import 'package:flutter/material.dart';
import '../../model/subject_model.dart';
import 'subject_header.dart';
import 'subject_item_list.dart';
import 'swipe_instructions.dart';

class SubjectCheckCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const SubjectCheckCard({
    Key? key,
    required this.subject,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SubjectHeader(subject: subject),
          SubjectItemList(items: subject.items),
          const SwipeInstructions(),
        ],
      ),
    );
  }
}
