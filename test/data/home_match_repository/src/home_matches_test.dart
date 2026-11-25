import 'package:flutter_test/flutter_test.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

void main() {
  const werder = 134;
  const otherTeam = 7;

  group('homeMatchesOf', () {
    test('keeps only matches where the team plays at home', () {
      final homeKickoff = DateTime.utc(2026, 9, 5, 13, 30);
      final matches = [
        ApiMatch(kickoff: homeKickoff, homeTeamId: werder),
        ApiMatch(kickoff: DateTime.utc(2026, 9, 12), homeTeamId: otherTeam),
      ];

      final homeMatches = homeMatchesOf(matches, teamId: werder);

      expect(homeMatches, [HomeMatch(kickoff: homeKickoff)]);
    });

    test('sorts the home matches by kickoff', () {
      final early = DateTime.utc(2026, 9, 5);
      final late = DateTime.utc(2026, 10, 17);
      final matches = [
        ApiMatch(kickoff: late, homeTeamId: werder),
        ApiMatch(kickoff: early, homeTeamId: werder),
      ];

      final homeMatches = homeMatchesOf(matches, teamId: werder);

      expect(homeMatches, [
        HomeMatch(kickoff: early),
        HomeMatch(kickoff: late),
      ]);
    });
  });
}
