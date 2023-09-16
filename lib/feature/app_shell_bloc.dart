import 'dart:async';

import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/feature/app_shell_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppShellBloc extends Cubit<AppShellState> {
  final RatingRepository ratingRepository;

  StreamSubscription? ratingStreamSubscription;

  AppShellBloc({required this.ratingRepository}) : super(AppShellState());

  Future<void> startGettingData() async {
    ratingStreamSubscription?.cancel();
    ratingStreamSubscription = ratingRepository.ratingStream.listen(
      (rating) {},
      onError: (error) {
        if (error is DioException) {
          emit(
            AppShellErrorState(
              message: error.message ?? error.error.toString(),
            ),
          );
        }
      },
    );
    ratingRepository.getRating();
  }

  @override
  Future<void> close() {
    ratingStreamSubscription?.cancel();
    return super.close();
  }
}
