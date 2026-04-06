import '../database/hive_boxes.dart';
import '../models/app_settings.dart';

class SettingsService {
  static const _settingsKey = 'app_settings';

  AppSettings load() {
    return HiveBoxes.settingsBox.get(_settingsKey) ?? AppSettings.defaults();
  }

  Future<void> save(AppSettings settings) async {
    await HiveBoxes.settingsBox.put(_settingsKey, settings);
  }
}
