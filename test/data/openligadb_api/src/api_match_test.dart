import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group(ApiMatch, () {
    late Map<String, dynamic> werderHomeMatchJson;

    setUpAll(() {
      final matches = jsonDecode(openLigaDbSampleResponse()) as List<dynamic>;
      werderHomeMatchJson = matches.first as Map<String, dynamic>;
    });

    test('reads the kickoff as UTC time', () {
      final match = ApiMatch.fromJson(werderHomeMatchJson);

      expect(match.kickoff, DateTime.utc(2026, 9, 5, 13, 30));
      expect(match.kickoff.isUtc, isTrue);
    });

    test('reads the id of the home team', () {
      final match = ApiMatch.fromJson(werderHomeMatchJson);

      expect(match.homeTeamId, 134);
    });
  });
}
