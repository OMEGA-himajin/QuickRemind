// 時間割データを管理するモデル
class TimetableModel {
  final String id;
  final List<String> mon;
  final List<String> tue;
  final List<String> wed;
  final List<String> thu;
  final List<String> fri;
  final List<String> sat;
  final List<String> sun;

  TimetableModel({
    required this.id,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  // Firestoreから取得したデータをオブジェクトに変換
  factory TimetableModel.fromMap(String id, Map<String, dynamic> data) {
    return TimetableModel(
      id: id,
      mon: List<String>.from(data['mon'] ?? []),
      tue: List<String>.from(data['tue'] ?? []),
      wed: List<String>.from(data['wed'] ?? []),
      thu: List<String>.from(data['thu'] ?? []),
      fri: List<String>.from(data['fri'] ?? []),
      sat: List<String>.from(data['sat'] ?? []),
      sun: List<String>.from(data['sun'] ?? []),
    );
  }

  // Firestoreに保存するためのMap変換
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
