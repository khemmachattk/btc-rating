import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

class Rating {
  final RatingTime time;
  final String disclaimer;
  final String chartName;
  final Map<String, Currency> bpi;

  Rating({
    required this.time,
    required this.disclaimer,
    required this.chartName,
    required this.bpi,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      time: RatingTime.fromJson(json['time']),
      disclaimer: json['disclaimer'],
      chartName: json['chartName'],
      bpi: (json['bpi'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          Currency.fromJson(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = time.toJson();
    map['disclaimer'] = disclaimer;
    map['chartName'] = chartName;
    map['bpi'] = bpi.map((key, value) => MapEntry(key, value.toJson()));
    return map;
  }
}

class Currency {
  final String code;
  final String symbol;
  final String rate;
  final String description;
  final num rateFloat;

  Currency({
    required this.code,
    required this.symbol,
    required this.rate,
    required this.description,
    required this.rateFloat,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    return Currency(
      code: json['code'],
      symbol: unescape.convert(json['symbol']),
      rate: json['rate'],
      description: json['description'],
      rateFloat: json['rate_float'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['symbol'] = htmlEscape.convert(symbol);
    map['rate'] = rate;
    map['description'] = description;
    map['rate_float'] = rateFloat;
    return map;
  }
}

class RatingTime {
  final String? updated;
  final String? updatedISO;
  final String? updateduk;

  RatingTime({
    required this.updated,
    required this.updatedISO,
    required this.updateduk,
  });

  factory RatingTime.fromJson(Map<String, dynamic> json) {
    return RatingTime(
      updated: json['updated'],
      updatedISO: json['updatedISO'],
      updateduk: json['updateduk'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['updated'] = updated;
    map['updatedISO'] = updatedISO;
    map['updateduk'] = updateduk;
    return map;
  }
}
