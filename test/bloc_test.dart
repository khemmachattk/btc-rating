import 'package:bloc_test/bloc_test.dart';
import 'package:btc_rate/core/domain/convert_btc_rate_use_case.dart';
import 'package:btc_rate/core/model/rating.dart';
import 'package:btc_rate/core/repository_impl/fake_rating_repository.dart';
import 'package:btc_rate/core/resource/fake_rating_resource.dart';
import 'package:btc_rate/feature/convert/convert_bloc.dart';
import 'package:btc_rate/feature/convert/convert_state.dart';
import 'package:btc_rate/feature/home/home_bloc.dart';
import 'package:btc_rate/feature/home/home_state.dart';
import 'package:btc_rate/feature/rating_history/currency_bloc.dart';
import 'package:btc_rate/feature/rating_history/currency_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeBloc', () {
    final fakeRatingResource = FakeRatingResource();
    final ratingRepository = FakeRatingRepository(
      fakeRatingResource: fakeRatingResource,
    );
    late final Rating expectRating;

    blocTest(
      'should retrieve data correctly',
      setUp: () async {
        ratingRepository.getRating();
        expectRating = await fakeRatingResource.getRating();
      },
      build: () => HomeBloc(ratingRepository: ratingRepository),
      act: (bloc) => bloc.startGettingData(),
      expect: () =>
      [
        HomeState(rating: expectRating),
      ],
    );
  });

  group('CurrencyBloc', () {
    final fakeRatingResource = FakeRatingResource();
    final ratingRepository = FakeRatingRepository(
      fakeRatingResource: fakeRatingResource,
    );
    const currencyCode = 'USD';
    late final Rating expectRating;

    blocTest(
      'should retrieve data correctly',
      setUp: () async {
        ratingRepository.getRating();
        expectRating = await fakeRatingResource.getRating();
      },
      build: () =>
          CurrencyBloc(
            ratingRepository: ratingRepository,
            code: currencyCode,
          ),
      act: (bloc) => bloc.startGettingData(),
      expect: () {
        final rating = expectRating;
        final currency = rating.bpi[currencyCode];
        return [
          CurrencyState(
            currency: currency,
            series: <String, num>{rating.time.updatedISO!: currency!.rateFloat},
          ),
        ];
      },
    );
  });

  group('ConvertBloc', () {
    final fakeRatingResource = FakeRatingResource();
    final ratingRepository = FakeRatingRepository(
      fakeRatingResource: fakeRatingResource,
    );
    final convertBtcRateUseCase = ConvertBtcRateUseCase();
    const currencyCode = 'USD';
    const usdAmount = 1000;
    late final Rating expectRating;

    blocTest(
      'should convert BTC correctly',
      setUp: () async {
        ratingRepository.getRating();
        expectRating = await fakeRatingResource.getRating();
      },
      build: () =>
          ConvertBloc(
            ratingRepository: ratingRepository,
            convertBtcRateUseCase: convertBtcRateUseCase,
          ),
      act: (bloc) async {
        bloc.startGettingData();
        await Future.delayed(Duration.zero);
        bloc
          ..selectCurrency(currencyCode)
          ..convertTo(usdAmount.toString());
      },
      expect: () {
        final rating = expectRating;
        final currency = rating.bpi[currencyCode]!;
        final options = rating.bpi.values.map((item) {
          return MapEntry(item.code, item.symbol);
        }).toList();

        return [
          ConvertState(
            currency: currency,
            options: options,
            from: null,
            to: '0.00000000',
          ),
          ConvertState(
            currency: currency,
            options: options,
            from: usdAmount.toString(),
            to: NumberFormat.decimalPatternDigits(
              decimalDigits: 8,
            ).format(
              usdAmount / currency.rateFloat,
            ),
          )
        ];
      },
    );
  });
}
