import 'package:btc_rate/core/domain/convert_btc_rate_use_case.dart';
import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/core/repository_impl/interval_rating_repository.dart';
import 'package:btc_rate/core/resource/network_rating_resource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final coreProviders = [
  ..._resources,
  ..._repositories,
  ..._useCases,
];

final _client = Dio(
  BaseOptions(baseUrl: 'https://api.coindesk.com'),
)..interceptors.add(PrettyDioLogger());

final _resources = [
  RepositoryProvider<NetworkRatingResource>(
    create: (context) => NetworkRatingResource(_client),
  ),
];

final _repositories = [
  RepositoryProvider<RatingRepository>(
    create: (context) => IntervalRatingRepository(
      networkRatingResource: context.read<NetworkRatingResource>(),
    ),
  ),
];

final _useCases = [
  RepositoryProvider<ConvertBtcRateUseCase>(
    create: (context) => ConvertBtcRateUseCase(),
  ),
];
