import 'package:werderwarn/data/home_match_repository/src/home_match.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

/// The home matches of the team with [teamId], sorted by kickoff.
List<HomeMatch> homeMatchesOf(List<ApiMatch> matches, {required int teamId}) =>
    matches
        .where((match) => match.homeTeamId == teamId)
        .map((match) => HomeMatch(kickoff: match.kickoff))
        .toList()
      ..sort((a, b) => a.kickoff.compareTo(b.kickoff));
