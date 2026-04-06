import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppSettings {
  AppSettings({
    required this.themeMode,
    required this.localeCode,
    required this.premiumEnabled,
    required this.notificationsEnabled,
  });

  final ThemeMode themeMode;
  final String localeCode;
  final bool premiumEnabled;
  final bool notificationsEnabled;

  factory AppSettings.defaults() {
    return AppSettings(
      themeMode: ThemeMode.system,
      localeCode: 'en',
      premiumEnabled: false,
      notificationsEnabled: false,
    );
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? localeCode,
    bool? premiumEnabled,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      premiumEnabled: premiumEnabled ?? this.premiumEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 11;

  @override
  AppSettings read(BinaryReader reader) {
    return AppSettings(
      themeMode: ThemeMode.values[reader.readInt()],
      localeCode: reader.readString(),
      premiumEnabled: reader.readBool(),
      notificationsEnabled: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeInt(obj.themeMode.index)
      ..writeString(obj.localeCode)
      ..writeBool(obj.premiumEnabled)
      ..writeBool(obj.notificationsEnabled);
  }
}
