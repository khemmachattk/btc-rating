import 'dart:async';

import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/core/resource/network_rating_resource.dart';
import 'package:dio/dio.dart';

class IntervalRatingRepository extends RatingRepository {
  final NetworkRatingResource networkRatingResource;

  Timer? intervalTimer;

  IntervalRatingRepository({required this.networkRatingResource});

  @override
  Future<void> getRating({int intervalSecond = 60}) async {
    intervalTimer?.cancel();
    intervalTimer = Timer.periodic(Duration(seconds: intervalSecond), (timer) {
      _fetchRating();
    });
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    try {
      final rating = await networkRatingResource.getRating();
      addToStream(rating);
    } on DioException catch (e) {
      ratingStream.addError(e);
    }
  }
}
