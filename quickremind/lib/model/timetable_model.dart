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
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun,
    };
  }

  List<String> getScheduleForDay(int day) {
    switch (day) {
      case 0:
        return mon;
      case 1:
        return tue;
      case 2:
        return wed;
      case 3:
        return thu;
      case 4:
        return fri;
      case 5:
        return sat;
      case 6:
        return sun;
      default:
        throw ArgumentError('Invalid day index: $day');
    }
  }

  void updateCell(int day, int period, String subjectId) {
    final schedule = getScheduleForDay(day);
    while (schedule.length <= period) {
      schedule.add('');
    }
    schedule[period] = subjectId;
  }

  String? getSubjectIdForCell(int day, int period) {
    final schedule = getScheduleForDay(day);
    while (schedule.length <= period) {
      schedule.add('');
    }
    return schedule[period];
  }
}
