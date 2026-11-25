/// A match as delivered by OpenLigaDB, reduced to the fields the app needs.
class ApiMatch {
  const new({required this.kickoff, required this.homeTeamId});

  factory fromJson(Map<String, dynamic> json) {
    final homeTeam = json['team1'] as Map<String, dynamic>;
    return ApiMatch(
      kickoff: DateTime.parse(json['matchDateTimeUTC'] as String),
      homeTeamId: homeTeam['teamId'] as int,
    );
  }

  final DateTime kickoff;
  final int homeTeamId;
}
