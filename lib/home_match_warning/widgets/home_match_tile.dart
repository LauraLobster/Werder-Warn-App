import 'package:material_ui/material_ui.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';

class HomeMatchTile extends StatelessWidget {
  const new({required this.match, super.key});

  final HomeMatch match;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.stadium),
      title: const Text('Heimspiel'),
      subtitle: Text(_formatLocal(match.kickoff)),
    );
  }

  String _formatLocal(DateTime kickoff) {
    final local = kickoff.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(local.day)}.${twoDigits(local.month)}.${local.year}, '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)} Uhr';
  }
}
