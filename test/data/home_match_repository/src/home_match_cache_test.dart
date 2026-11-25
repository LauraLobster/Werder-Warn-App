import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';

void main() {
  group(SharedPreferencesHomeMatchCache, () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('reads nothing before anything was saved', () async {
      final cache = SharedPreferencesHomeMatchCache(
        await SharedPreferences.getInstance(),
      );

      expect(await cache.read(), isEmpty);
    });

    test('reads the home matches that were saved', () async {
      final cache = SharedPreferencesHomeMatchCache(
        await SharedPreferences.getInstance(),
      );
      final matches = [
        HomeMatch(kickoff: DateTime.utc(2026, 9, 5, 13, 30)),
        HomeMatch(kickoff: DateTime.utc(2026, 9, 19, 13, 30)),
      ];

      await cache.save(matches);

      expect(await cache.read(), matches);
    });

    test('replaces previously saved home matches', () async {
      final cache = SharedPreferencesHomeMatchCache(
        await SharedPreferences.getInstance(),
      );
      final latest = [HomeMatch(kickoff: DateTime.utc(2026, 10, 17))];

      await cache.save([HomeMatch(kickoff: DateTime.utc(2026, 9, 5))]);
      await cache.save(latest);

      expect(await cache.read(), latest);
    });
  });
}
