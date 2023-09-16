import 'dart:convert';

import 'package:btc_rate/core/model/rating.dart';
import 'package:dio/dio.dart';

class NetworkRatingResource {
  final Dio client;

  NetworkRatingResource(this.client);

  Future<Rating> getRating() async {
    final result = await client.get('/v1/bpi/currentprice.json');
    return Rating.fromJson(jsonDecode(result.data));
  }
}
