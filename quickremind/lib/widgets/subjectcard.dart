import 'package:flutter/material.dart';
import '../model/subject_model.dart';

class ConfirmationCard extends StatelessWidget {
  final SubjectModel subject;

  const ConfirmationCard({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: subject.items.map((item) => Text('・$item')).toList(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 4),
                Text('保留')
              ]),
              Row(children: [
                Text('確認'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward)
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
