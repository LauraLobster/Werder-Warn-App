import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:werderwarn/home_match_warning/cubit/home_matches_cubit.dart';
import 'package:werderwarn/home_match_warning/widgets/home_match_tile.dart';

/// Placeholder screen: lists the upcoming home matches until the actual
/// warning UI of epic #1 replaces it.
class HomeMatchWarningView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Werder-Heimspiele')),
      body: BlocBuilder<HomeMatchesCubit, HomeMatchesState>(
        builder: (context, state) => switch (state.status) {
          HomeMatchesStatus.initial || HomeMatchesStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          HomeMatchesStatus.failure => const _LoadingFailed(),
          HomeMatchesStatus.success when state.matches.isEmpty => const Center(
            child: Text('Keine anstehenden Heimspiele'),
          ),
          HomeMatchesStatus.success => ListView(
            children: [
              for (final match in state.matches) HomeMatchTile(match: match),
            ],
          ),
        },
      ),
    );
  }
}

class _LoadingFailed extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          const Text('Der Spielplan konnte nicht geladen werden.'),
          TextButton(
            onPressed: () => context.read<HomeMatchesCubit>().load(),
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }
}
