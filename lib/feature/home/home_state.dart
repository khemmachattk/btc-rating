import 'package:btc_rate/core/model/rating.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final Rating? rating;

  const HomeState({required this.rating});

  @override
  List<Object?> get props => [rating?.toJson().toString()];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState({super.rating});
}
