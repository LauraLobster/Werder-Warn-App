import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:werderwarn/app/app.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/home_match_warning.dart';

class _MockHomeMatchRepository extends Mock implements HomeMatchRepository;

void main() {
  group(App, () {
    testWidgets('loads and shows the upcoming home matches', (tester) async {
      final repository = _MockHomeMatchRepository();
      when(repository.loadUpcomingHomeMatches).thenAnswer(
        (_) async => [HomeMatch(kickoff: DateTime.utc(2026, 11, 28, 14, 30))],
      );

      await tester.pumpWidget(App(homeMatchRepository: repository));
      await tester.pumpAndSettle();

      expect(find.byType(HomeMatchTile), findsOneWidget);
    });
  });
}
