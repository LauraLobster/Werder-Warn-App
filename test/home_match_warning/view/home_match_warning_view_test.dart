import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/home_match_warning.dart';

class _MockHomeMatchesCubit extends MockCubit<HomeMatchesState>
    implements HomeMatchesCubit;

void main() {
  late _MockHomeMatchesCubit cubit;

  setUp(() => cubit = _MockHomeMatchesCubit());

  Future<void> showView(WidgetTester tester, HomeMatchesState state) {
    when(() => cubit.state).thenReturn(state);
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeMatchesCubit>.value(
          value: cubit,
          child: const HomeMatchWarningView(),
        ),
      ),
    );
  }

  group(HomeMatchWarningView, () {
    testWidgets('shows a progress indicator while loading', (tester) async {
      await showView(
        tester,
        const HomeMatchesState(status: HomeMatchesStatus.loading),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows one tile per upcoming home match', (tester) async {
      await showView(
        tester,
        HomeMatchesState(
          status: HomeMatchesStatus.success,
          matches: [
            HomeMatch(kickoff: DateTime.utc(2026, 11, 28, 14, 30)),
            HomeMatch(kickoff: DateTime.utc(2026, 12, 13, 18, 30)),
          ],
        ),
      );

      expect(find.byType(HomeMatchTile), findsNWidgets(2));
    });

    testWidgets('says so when no home match is coming up', (tester) async {
      await showView(
        tester,
        const HomeMatchesState(status: HomeMatchesStatus.success),
      );

      expect(find.text('Keine anstehenden Heimspiele'), findsOneWidget);
    });

    testWidgets('offers to retry when loading failed', (tester) async {
      when(() => cubit.load()).thenAnswer((_) async {});
      await showView(
        tester,
        const HomeMatchesState(status: HomeMatchesStatus.failure),
      );

      await tester.tap(find.text('Erneut versuchen'));

      verify(() => cubit.load()).called(1);
    });
  });
}
