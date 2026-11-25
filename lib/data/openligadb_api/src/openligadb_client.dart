import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:werderwarn/data/openligadb_api/src/api_match.dart';

/// Thrown when OpenLigaDB cannot deliver usable match data.
class OpenLigaDbException implements Exception {
  const new(this.reason);

  final String reason;

  @override
  String toString() => 'OpenLigaDbException: $reason';
}

/// Reads Bundesliga matches from https://www.openligadb.de.
class OpenLigaDbClient {
  new({required this._httpClient});

  static const _baseUrl = 'https://api.openligadb.de';
  static const _bundesliga = 'bl1';

  final http.Client _httpClient;

  /// All Bundesliga matches of [season], e.g. 2026 for 2026/27.
  Future<List<ApiMatch>> fetchMatches({required int season}) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/getmatchdata/$_bundesliga/$season'),
    );
    if (response.statusCode != 200) {
      throw OpenLigaDbException('HTTP ${response.statusCode}');
    }
    return _parseMatches(response.body);
  }

  List<ApiMatch> _parseMatches(String body) {
    try {
      final matches = jsonDecode(body) as List<dynamic>;
      return matches
          .map((match) => ApiMatch.fromJson(match as Map<String, dynamic>))
          .toList();
    } on Object catch (error) {
      throw OpenLigaDbException('Malformed response: $error');
    }
  }
}
