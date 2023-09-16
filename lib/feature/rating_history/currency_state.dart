import 'package:btc_rate/core/model/rating.dart';
import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final Currency? currency;
  final Map<String, num> series;

  const CurrencyState({
    required this.currency,
    required this.series,
  });

  @override
  List<Object?> get props => [
        currency?.toJson().toString(),
        series.toString(),
      ];
}
