import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group(OpenLigaDbClient, () {
    test('requests the Bundesliga matches of the given season', () async {
      Uri? requestedUrl;
      final client = OpenLigaDbClient(
        httpClient: MockClient((request) async {
          requestedUrl = request.url;
          return http.Response('[]', 200);
        }),
      );

      await client.fetchMatches(season: 2026);

      expect(
        requestedUrl,
        Uri.parse('https://api.openligadb.de/getmatchdata/bl1/2026'),
      );
    });

    test('returns all matches of the response', () async {
      final client = OpenLigaDbClient(
        httpClient: MockClient(
          (_) async => http.Response(
            openLigaDbSampleResponse(),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ),
        ),
      );

      final matches = await client.fetchMatches(season: 2026);

      expect(matches.map((match) => match.homeTeamId), [134, 112, 40]);
    });

    test('throws when the server does not answer with 200', () async {
      final client = OpenLigaDbClient(
        httpClient: MockClient((_) async => http.Response('', 500)),
      );

      expect(
        () => client.fetchMatches(season: 2026),
        throwsA(isA<OpenLigaDbException>()),
      );
    });

    test('throws when the response is not valid match data', () async {
      final client = OpenLigaDbClient(
        httpClient: MockClient((_) async => http.Response('{"oops": 1}', 200)),
      );

      expect(
        () => client.fetchMatches(season: 2026),
        throwsA(isA<OpenLigaDbException>()),
      );
    });
  });
}
