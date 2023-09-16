import 'dart:async';

import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/rating_history/currency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyBloc extends Cubit<CurrencyState> {
  final RatingRepository ratingRepository;
  final String code;

  StreamSubscription? ratingStreamSubscription;

  CurrencyBloc({required this.ratingRepository, required this.code})
      : super(const CurrencyState(currency: null, series: {}));

  void startGettingData() async {
    await _getInitialSeries();
    ratingStreamSubscription?.cancel();
    ratingStreamSubscription = ratingRepository.ratingStream.listen(
      (rating) {
        final series = Map<String, num>.from(state.series);
        series[rating.time.updatedISO!] = rating.bpi[code]!.rateFloat;
        emit(CurrencyState(currency: rating.bpi[code], series: series));
      },
    );
  }

  Future<void> _getInitialSeries() async {
    final ratings = ratingRepository.cacheRatingStream.values;
    final Map<String, num> series = {};
    for (final rating in ratings) {
      series[rating.time.updatedISO!] = rating.bpi[code]!.rateFloat;
    }
    if (series.isNotEmpty) {
      emit(CurrencyState(currency: ratings.last.bpi[code], series: series));
    }
  }

  @override
  Future<void> close() {
    ratingStreamSubscription?.cancel();
    return super.close();
  }
}
