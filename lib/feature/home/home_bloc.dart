import 'dart:async';

import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Cubit<HomeState> {
  final RatingRepository ratingRepository;

  StreamSubscription? ratingStreamSubscription;

  HomeBloc({required this.ratingRepository})
      : super(const HomeLoadingState());

  Future<void> startGettingData() async {
    ratingStreamSubscription?.cancel();
    ratingStreamSubscription = ratingRepository.ratingStream.listen(
      (rating) {
        emit(HomeState(rating: rating));
      },
    );
  }

  @override
  Future<void> close() {
    ratingStreamSubscription?.cancel();
    return super.close();
  }
}
