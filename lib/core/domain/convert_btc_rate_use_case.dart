import 'package:btc_rate/core/model/rating.dart';

class ConvertBtcRateUseCase {
  num invoke(String? value, Currency? currency) {
    if (value == null || currency == null) return 0;
    try {
      final amount = num.parse(value);
      return amount / currency.rateFloat;
    } catch (e) {
      return 0;
    }
  }
}
