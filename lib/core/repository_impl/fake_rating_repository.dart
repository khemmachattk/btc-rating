import 'package:btc_rate/core/repository/rating_repository.dart';
import 'package:btc_rate/core/resource/fake_rating_resource.dart';

class FakeRatingRepository extends RatingRepository {
  final FakeRatingResource fakeRatingResource;

  FakeRatingRepository({required this.fakeRatingResource});

  @override
  void getRating() async {
    final rating = await fakeRatingResource.getRating();
    addToStream(rating);
  }
}
