import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

class _MockOpenLigaDbClient extends Mock implements OpenLigaDbClient;

class _MockHomeMatchCache extends Mock implements HomeMatchCache;

void main() {
  const werder = 134;
  final now = DateTime.utc(2026, 11, 25, 12);
  final pastKickoff = DateTime.utc(2026, 9, 5, 13, 30);
  final upcomingKickoff = DateTime.utc(2026, 11, 28, 14, 30);

  late _MockOpenLigaDbClient client;
  late _MockHomeMatchCache cache;

  setUpAll(() => registerFallbackValue(<HomeMatch>[]));

  setUp(() {
    client = _MockOpenLigaDbClient();
    cache = _MockHomeMatchCache();
    when(() => cache.save(any())).thenAnswer((_) async {});
    when(() => cache.read()).thenAnswer((_) async => []);
  });

  HomeMatchRepository repositoryAt(DateTime time) =>
      HomeMatchRepository(client: client, cache: cache, now: () => time);

  void serveMatches(List<ApiMatch> matches) =>
      when(() => client.fetchMatches(season: any(named: 'season')))
          .thenAnswer((_) async => matches);

  void failToServeMatches() =>
      when(() => client.fetchMatches(season: any(named: 'season')))
          .thenThrow(const OpenLigaDbException('offline'));

  group(HomeMatchRepository, () {
    group('during the first half of a season', () {
      test('loads the season that started this year', () async {
        serveMatches([]);

        await repositoryAt(now).loadUpcomingHomeMatches();

        verify(() => client.fetchMatches(season: 2026)).called(1);
      });
    });

    group('during the second half of a season', () {
      test('loads the season that started last year', () async {
        serveMatches([]);

        await repositoryAt(DateTime.utc(2027, 3)).loadUpcomingHomeMatches();

        verify(() => client.fetchMatches(season: 2026)).called(1);
      });
    });

    test('returns only home matches that are still to come', () async {
      serveMatches([
        ApiMatch(kickoff: pastKickoff, homeTeamId: werder),
        ApiMatch(kickoff: upcomingKickoff, homeTeamId: werder),
        ApiMatch(kickoff: upcomingKickoff, homeTeamId: 7),
      ]);

      final matches = await repositoryAt(now).loadUpcomingHomeMatches();

      expect(matches, [HomeMatch(kickoff: upcomingKickoff)]);
    });

    test('saves the loaded home matches', () async {
      serveMatches([
        ApiMatch(kickoff: pastKickoff, homeTeamId: werder),
        ApiMatch(kickoff: upcomingKickoff, homeTeamId: 7),
      ]);

      await repositoryAt(now).loadUpcomingHomeMatches();

      verify(() => cache.save([HomeMatch(kickoff: pastKickoff)])).called(1);
    });

    group('when the schedule cannot be loaded', () {
      setUp(failToServeMatches);

      test('returns the upcoming home matches saved last time', () async {
        when(() => cache.read()).thenAnswer(
          (_) async => [
            HomeMatch(kickoff: pastKickoff),
            HomeMatch(kickoff: upcomingKickoff),
          ],
        );

        final matches = await repositoryAt(now).loadUpcomingHomeMatches();

        expect(matches, [HomeMatch(kickoff: upcomingKickoff)]);
      });

      test('throws if nothing was saved before', () async {
        expect(
          () => repositoryAt(now).loadUpcomingHomeMatches(),
          throwsA(isA<HomeMatchesUnavailableException>()),
        );
      });
    });
  });
}
