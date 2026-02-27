import 'package:flutter/material.dart';

enum HabitFrequency { daily, weekly, custom }

class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.targetPerDay,
    required this.scheduledWeekdays,
    required this.reminderHour,
    required this.reminderMinute,
    required this.colorValue,
    required this.iconCodePoint,
    this.archived = false,
    this.completions = const {},
  });

  final String id;
  final String name;
  final HabitFrequency frequency;
  final int targetPerDay;
  final List<int> scheduledWeekdays;
  final int reminderHour;
  final int reminderMinute;
  final int colorValue;
  final int iconCodePoint;
  final bool archived;
  final Map<String, int> completions;

  Color get color => Color(colorValue);
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Habit copyWith({
    String? name,
    HabitFrequency? frequency,
    int? targetPerDay,
    List<int>? scheduledWeekdays,
    int? reminderHour,
    int? reminderMinute,
    int? colorValue,
    int? iconCodePoint,
    bool? archived,
    Map<String, int>? completions,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      scheduledWeekdays: scheduledWeekdays ?? this.scheduledWeekdays,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      archived: archived ?? this.archived,
      completions: completions ?? this.completions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'frequency': frequency.name,
        'targetPerDay': targetPerDay,
        'scheduledWeekdays': scheduledWeekdays,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'colorValue': colorValue,
        'iconCodePoint': iconCodePoint,
        'archived': archived,
        'completions': completions,
      };

  static Habit fromJson(Map<String, dynamic> map) => Habit(
        id: map['id'] as String,
        name: map['name'] as String,
        frequency: HabitFrequency.values.byName(map['frequency'] as String),
        targetPerDay: map['targetPerDay'] as int,
        scheduledWeekdays: (map['scheduledWeekdays'] as List).cast<int>(),
        reminderHour: map['reminderHour'] as int,
        reminderMinute: map['reminderMinute'] as int,
        colorValue: map['colorValue'] as int,
        iconCodePoint: map['iconCodePoint'] as int,
        archived: map['archived'] as bool? ?? false,
        completions: (map['completions'] as Map? ?? {}).map(
          (k, v) => MapEntry(k.toString(), v as int),
        ),
      );
}
