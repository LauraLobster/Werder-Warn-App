import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/home_match_warning.dart';

void main() {
  group(HomeMatchTile, () {
    testWidgets('shows the kickoff in local time', (tester) async {
      final localKickoff = DateTime(2026, 11, 28, 15, 30);
      final match = HomeMatch(kickoff: localKickoff.toUtc());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: HomeMatchTile(match: match)),
        ),
      );

      expect(find.text('Heimspiel'), findsOneWidget);
      expect(find.text('28.11.2026, 15:30 Uhr'), findsOneWidget);
    });
  });
}
