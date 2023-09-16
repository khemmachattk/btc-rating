import 'package:btc_rate/core/model/rating.dart';
import 'package:rxdart/rxdart.dart';

abstract class RatingRepository {
  final ratingStream = BehaviorSubject<Rating>();
  final cacheRatingStream = ReplaySubject<Rating>();

  void getRating();

  void addToStream(Rating rating) {
    ratingStream.add(rating);
    cacheRatingStream.add(rating);
  }
}
