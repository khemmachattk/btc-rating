import 'package:btc_rate/app_router.dart';
import 'package:btc_rate/core/di.dart';
import 'package:btc_rate/feature/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BTCRateApp extends StatelessWidget {
  const BTCRateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...coreProviders,
        ...featureProviders,
      ],
      child: MaterialApp.router(
        title: 'BTC Rate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
