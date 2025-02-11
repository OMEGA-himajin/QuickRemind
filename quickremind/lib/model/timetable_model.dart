class TimetableModel {
  String id;
  List<List<String>> days;

  TimetableModel({
    required this.id,
    required this.days,
  });

  List<String> get mon => days[0];
  List<String> get tue => days[1];
  List<String> get wed => days[2];
  List<String> get thu => days[3];
  List<String> get fri => days[4];
  List<String> get sat => days[5];
  List<String> get sun => days[6];

  factory TimetableModel.fromMap(String id, Map<String, dynamic> data) {
    return TimetableModel(
      id: id,
      days: [
        List<String>.from(data['mon'] ?? []),
        List<String>.from(data['tue'] ?? []),
        List<String>.from(data['wed'] ?? []),
        List<String>.from(data['thu'] ?? []),
        List<String>.from(data['fri'] ?? []),
        List<String>.from(data['sat'] ?? []),
        List<String>.from(data['sun'] ?? []),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mon': days[0],
      'tue': days[1],
      'wed': days[2],
      'thu': days[3],
      'fri': days[4],
      'sat': days[5],
      'sun': days[6],
    };
  }

  void ensureSize(int periods) {
    for (int i = 0; i < 7; i++) {
      while (days[i].length < periods) {
        days[i].add('');
      }
      if (days[i].length > periods) {
        days[i] = days[i].sublist(0, periods);
      }
    }
  }
}
