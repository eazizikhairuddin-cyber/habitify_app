import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static const bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  static Future<InitializationStatus> initialize() {
    return MobileAds.instance.initialize();
  }
}
