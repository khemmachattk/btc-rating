import 'package:btc_rate/core/model/rating.dart';
import 'package:equatable/equatable.dart';

class ConvertState extends Equatable {
  final Currency? currency;
  final List<MapEntry<String, String>>? options;
  final String? from;
  final String? to;

  const ConvertState({
    required this.currency,
    required this.options,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [
        currency?.toJson().toString(),
        options.toString(),
        from,
        to,
      ];
}

class ConvertLoadingState extends ConvertState {
  const ConvertLoadingState({
    super.currency,
    super.options,
    super.from,
    super.to,
  });
}
