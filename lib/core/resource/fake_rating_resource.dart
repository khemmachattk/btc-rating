import 'dart:convert';

import 'package:btc_rate/core/model/rating.dart';
import 'package:flutter/services.dart';

class FakeRatingResource {
  FakeRatingResource();

  Future<Rating> getRating() async {
    final data = await rootBundle.loadString('assets/mock/rating.json');
    return Rating.fromJson(jsonDecode(data));
  }
}