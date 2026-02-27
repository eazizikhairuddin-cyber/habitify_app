class JournalEntry {
  JournalEntry({
    required this.dateKey,
    required this.note,
    required this.mood,
  });

  final String dateKey;
  final String note;
  final int mood;

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'note': note,
        'mood': mood,
      };

  static JournalEntry fromJson(Map<String, dynamic> map) => JournalEntry(
        dateKey: map['dateKey'] as String,
        note: map['note'] as String,
        mood: map['mood'] as int,
      );
}
