import 'package:werderwarn/data/home_match_repository/src/home_match.dart';
import 'package:werderwarn/data/home_match_repository/src/home_match_cache.dart';
import 'package:werderwarn/data/home_match_repository/src/home_matches.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

/// Thrown when home matches can neither be loaded nor read from the cache.
class HomeMatchesUnavailableException implements Exception {
  const new();
}

/// Provides the upcoming Werder Bremen home matches, online or from the cache.
class HomeMatchRepository {
  new({required this._client, required this._cache, this._now = DateTime.now});

  static const _werderBremenTeamId = 134;

  /// Bundesliga seasons start in August; July is the first month of a season.
  static const int _firstMonthOfSeason = DateTime.july;

  final OpenLigaDbClient _client;
  final HomeMatchCache _cache;
  final DateTime Function() _now;

  Future<List<HomeMatch>> loadUpcomingHomeMatches() async {
    final now = _now();
    final homeMatches = await _loadSeason(_seasonAt(now));
    return homeMatches.where((match) => !match.kickoff.isBefore(now)).toList();
  }

  Future<List<HomeMatch>> _loadSeason(int season) async {
    try {
      final matches = await _client.fetchMatches(season: season);
      final homeMatches = homeMatchesOf(matches, teamId: _werderBremenTeamId);
      await _cache.save(homeMatches);
      return homeMatches;
    } on Exception {
      return await _readCache();
    }
  }

  Future<List<HomeMatch>> _readCache() async {
    final cached = await _cache.read();
    if (cached.isEmpty) throw const HomeMatchesUnavailableException();
    return cached;
  }

  int _seasonAt(DateTime time) =>
      time.month >= _firstMonthOfSeason ? time.year : time.year - 1;
}
