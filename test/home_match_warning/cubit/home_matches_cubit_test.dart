import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/home_match_warning.dart';

class _MockHomeMatchRepository extends Mock implements HomeMatchRepository;

void main() {
  final matches = [HomeMatch(kickoff: DateTime.utc(2026, 11, 28, 14, 30))];

  late _MockHomeMatchRepository repository;

  setUp(() => repository = _MockHomeMatchRepository());

  group(HomeMatchesCubit, () {
    test('starts in the initial state', () {
      expect(HomeMatchesCubit(repository).state, const HomeMatchesState());
    });

    blocTest<HomeMatchesCubit, HomeMatchesState>(
      'emits the loaded home matches',
      setUp: () =>
          when(repository.loadUpcomingHomeMatches)
              .thenAnswer((_) async => matches),
      build: () => HomeMatchesCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeMatchesState(status: HomeMatchesStatus.loading),
        HomeMatchesState(status: HomeMatchesStatus.success, matches: matches),
      ],
    );

    blocTest<HomeMatchesCubit, HomeMatchesState>(
      'emits a failure when no home matches are available',
      setUp: () =>
          when(repository.loadUpcomingHomeMatches)
              .thenThrow(const HomeMatchesUnavailableException()),
      build: () => HomeMatchesCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [
        HomeMatchesState(status: HomeMatchesStatus.loading),
        HomeMatchesState(status: HomeMatchesStatus.failure),
      ],
    );
  });
}
