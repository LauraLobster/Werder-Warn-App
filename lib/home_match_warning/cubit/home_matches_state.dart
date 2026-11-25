part of 'home_matches_cubit.dart';

enum HomeMatchesStatus { initial, loading, success, failure }

class HomeMatchesState extends Equatable {
  const new({this.status = HomeMatchesStatus.initial, this.matches = const []});

  final HomeMatchesStatus status;
  final List<HomeMatch> matches;

  @override
  List<Object> get props => [status, matches];
}
