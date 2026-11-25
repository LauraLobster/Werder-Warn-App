import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:werderwarn/data/home_match_repository/src/home_match.dart';

/// Keeps the last loaded home matches for offline use.
abstract interface class HomeMatchCache {
  Future<void> save(List<HomeMatch> matches);

  /// The saved home matches, or an empty list if nothing was saved yet.
  Future<List<HomeMatch>> read();
}

class SharedPreferencesHomeMatchCache implements HomeMatchCache {
  const new(this._preferences);

  static const _key = 'home_matches';

  final SharedPreferences _preferences;

  @override
  Future<void> save(List<HomeMatch> matches) => _preferences.setString(
    _key,
    jsonEncode(matches.map((match) => match.toJson()).toList()),
  );

  @override
  Future<List<HomeMatch>> read() async {
    final saved = _preferences.getString(_key);
    if (saved == null) return [];
    return (jsonDecode(saved) as List<dynamic>)
        .map((match) => HomeMatch.fromJson(match as Map<String, dynamic>))
        .toList();
  }
}
