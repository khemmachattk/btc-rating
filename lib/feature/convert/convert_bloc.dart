import 'dart:async';

import 'package:btc_rate/core/domain/convert_btc_rate_use_case.dart';
import 'package:btc_rate/core/model/rating.dart';
import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/convert/convert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConvertBloc extends Cubit<ConvertState> {
  final RatingRepository ratingRepository;
  final ConvertBtcRateUseCase convertBtcRateUseCase;

  StreamSubscription? ratingStreamSubscription;

  ConvertBloc({
    required this.ratingRepository,
    required this.convertBtcRateUseCase,
  }) : super(const ConvertLoadingState());

  Future<void> startGettingData() async {
    ratingStreamSubscription?.cancel();
    ratingStreamSubscription = ratingRepository.ratingStream.listen(
      (rating) => _mapDataToState(rating),
    );
  }

  void _mapDataToState(Rating rating, {Currency? forceCurrency}) {
    final currency = forceCurrency ??
        rating.bpi[state.currency?.code] ??
        rating.bpi.values.first;
    final options = rating.bpi.values.map((item) {
      return MapEntry(item.code, item.symbol);
    }).toList();
    emit(
      ConvertState(
        currency: currency,
        options: options,
        from: state.from,
        to: _convertBtc(state.from, currency),
      ),
    );
  }

  Future<void> selectCurrency(String? code) async {
    final rating = ratingRepository.ratingStream.value;
    _mapDataToState(rating, forceCurrency: rating.bpi[code]);
  }

  String _convertBtc(String? value, Currency? currency) {
    final btcAmount = convertBtcRateUseCase.invoke(value, currency);
    return NumberFormat.decimalPatternDigits(decimalDigits: 8).format(btcAmount);
  }

  String? convertTo(String? value) {
    emit(
      ConvertState(
        currency: state.currency,
        options: state.options,
        from: value,
        to: _convertBtc(value, state.currency),
      ),
    );
    return value;
  }

  @override
  Future<void> close() {
    ratingStreamSubscription?.cancel();
    return super.close();
  }
}
