import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/home_match_warning.dart';

class App extends StatelessWidget {
  const new({required this._homeMatchRepository, super.key});

  static const _werderGreen = Color(0xFF1D9053);

  final HomeMatchRepository _homeMatchRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _homeMatchRepository,
      child: MaterialApp(
        title: 'Werder Warn',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: _werderGreen)),
        home: const HomeMatchWarningPage(),
      ),
    );
  }
}
