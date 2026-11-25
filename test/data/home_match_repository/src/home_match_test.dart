import 'package:flutter_test/flutter_test.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';

void main() {
  group(HomeMatch, () {
    test('survives a round trip through JSON', () {
      final match = HomeMatch(kickoff: DateTime.utc(2026, 9, 5, 13, 30));

      expect(HomeMatch.fromJson(match.toJson()), match);
    });

    test('restores the kickoff as UTC time', () {
      final match = HomeMatch(kickoff: DateTime.utc(2026, 9, 5, 13, 30));

      expect(HomeMatch.fromJson(match.toJson()).kickoff.isUtc, isTrue);
    });
  });
}
