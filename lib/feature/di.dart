import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/app_shell_bloc.dart';
import 'package:btc_rate/feature/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final featureProviders = [
  BlocProvider<AppShellBloc>(
    create: (context) => AppShellBloc(
      ratingRepository: context.read<RatingRepository>(),
    ),
  ),
  BlocProvider<HomeBloc>(
    create: (context) => HomeBloc(
      ratingRepository: context.read<RatingRepository>(),
    ),
  ),
];
