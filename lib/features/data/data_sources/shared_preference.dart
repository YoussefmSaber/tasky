import 'package:shared_preferences/shared_preferences.dart';

/// A service for managing shared preferences.
class SharedPreferenceService {
  final SharedPreferences _prefs;

  /// Creates a new instance of [SharedPreferenceService].
  ///
  /// Takes a [SharedPreferences] instance as a parameter.
  SharedPreferenceService(this._prefs);

  Future<void> saveOnboardingState() async {
    await _prefs.setBool("onboarding", true);
  }

  /// Saves the access token to shared preferences.
  ///
  /// Takes a [String] token as a parameter.
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString('access_token', token);
  }

  /// Retrieves the access token from shared preferences.
  ///
  /// Returns the access token as a [String], or null if not found.
  String? getAccessToken() {
    return _prefs.getString('access_token');
  }

  /// Saves the refresh token to shared preferences.
  ///
  /// Takes a [String] token as a parameter.
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString('refresh_token', token);
  }

  /// Retrieves the refresh token from shared preferences.
  ///
  /// Returns the refresh token as a [String], or null if not found.
  String? getRefreshToken() {
    return _prefs.getString('refresh_token');
  }

  /// Clears the access and refresh tokens from shared preferences.
  Future<void> clearTokens() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
  }
}
