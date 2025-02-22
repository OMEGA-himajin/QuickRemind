import 'package:flutter/material.dart';
import '../../model/subject_model.dart';

class SubjectHeader extends StatelessWidget {
  final SubjectModel subject;

  const SubjectHeader({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        subject.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
