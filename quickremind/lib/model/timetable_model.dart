class TimetableModel {
  String id;
  List<String> mon;
  List<String> tue;
  List<String> wed;
  List<String> thu;
  List<String> fri;
  List<String> sat;
  List<String> sun;

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
}
