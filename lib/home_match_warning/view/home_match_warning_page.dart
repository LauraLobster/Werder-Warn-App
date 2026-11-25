import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/home_match_warning/cubit/home_matches_cubit.dart';
import 'package:werderwarn/home_match_warning/view/home_match_warning_view.dart';

class HomeMatchWarningPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = HomeMatchesCubit(context.read<HomeMatchRepository>());
        unawaited(cubit.load());
        return cubit;
      },
      child: const HomeMatchWarningView(),
    );
  }
}
