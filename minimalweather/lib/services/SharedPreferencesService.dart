import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static String getCity() => _getString("city") ?? "London";
  static double getLatitude() => _getDouble("lat");
  static double getLongitude() => _getDouble("lon");

  static Future<void> setCity(String value) async => await _setString("city", value);
  static Future<void> setLatitude(double value) async => await _setDouble("lat", value);
  static Future<void> setLongitude(double value) async => await _setDouble("lon", value);

  static String _getString(String key) => _prefs.getString(key);
  static double _getDouble(String key) => _prefs.getDouble(key);

  static Future<void> _setString(String key, String value) async => await _prefs.setString(key, value);
  static Future<void> _setDouble(String key, double value) async => await _prefs.setDouble(key, value);
}
