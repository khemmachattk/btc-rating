import 'package:btc_rate/core/domain/convert_btc_rate_use_case.dart';
import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/app_shell.dart';
import 'package:btc_rate/feature/convert/convert_bloc.dart';
import 'package:btc_rate/feature/convert/convert_screen.dart';
import 'package:btc_rate/feature/home/home_screen.dart';
import 'package:btc_rate/feature/rating_history/currency_bloc.dart';
import 'package:btc_rate/feature/rating_history/currency_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) {
        return AppShell(navShell: navShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'currency/:code',
                  builder: (context, state) {
                    final code = state.pathParameters['code']!;
                    return _currencyScreen(code);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/convert',
              builder: (context, state) {
                return _convertScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget _convertScreen() {
  return BlocProvider(
    create: (context) => ConvertBloc(
      ratingRepository: context.read<RatingRepository>(),
      convertBtcRateUseCase: context.read<ConvertBtcRateUseCase>(),
    ),
    child: const ConvertScreen(),
  );
}

Widget _currencyScreen(String code) {
  return BlocProvider(
    create: (context) {
      return CurrencyBloc(
        code: code,
        ratingRepository: context.read<RatingRepository>(),
      );
    },
    child: const CurrencyScreen(),
  );
}
