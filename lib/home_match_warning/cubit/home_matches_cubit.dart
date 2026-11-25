import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';

part 'home_matches_state.dart';

class HomeMatchesCubit extends Cubit<HomeMatchesState> {
  new(this._repository) : super(const HomeMatchesState());

  final HomeMatchRepository _repository;

  Future<void> load() async {
    emit(const HomeMatchesState(status: HomeMatchesStatus.loading));
    try {
      final matches = await _repository.loadUpcomingHomeMatches();
      emit(
        HomeMatchesState(status: HomeMatchesStatus.success, matches: matches),
      );
    } on HomeMatchesUnavailableException {
      emit(const HomeMatchesState(status: HomeMatchesStatus.failure));
    }
  }
}
