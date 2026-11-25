import 'package:equatable/equatable.dart';

/// A Werder Bremen home match. The kickoff is all a warning needs.
class HomeMatch extends Equatable {
  const new({required this.kickoff});

  factory fromJson(Map<String, dynamic> json) =>
      HomeMatch(kickoff: DateTime.parse(json['kickoff'] as String));

  /// Kickoff in UTC.
  final DateTime kickoff;

  Map<String, dynamic> toJson() => {'kickoff': kickoff.toIso8601String()};

  @override
  List<Object> get props => [kickoff];
}
