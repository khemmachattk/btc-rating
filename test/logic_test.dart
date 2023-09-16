import 'package:flutter_test/flutter_test.dart';

/// จงเขียนฟังก์ชัน validate pincode ที่จะรับค่าเข้ามาเป็นตัวเลขเท่านั้น โดยมีเงื่อนไขดังนี้ (ใช้เวลาในการทำทั้งหมด 60 นาที
/// 1. input จะต้องมีความยาวมากกว่าหรือเท่ากับ 6 ตัวอักษร เช่น
/// 17283 ❌
/// 172839 ✅
/// 2. input จะต้องกันไม่ให้มีเลขซ้ำติดกันเกิน 2 ตัว
/// 111822 ❌
/// 112762 ✅
/// 3. input จะต้องกันไม่ให้มีเลขเรียงกันเกิน 2 ตัว
/// 123743 ❌
/// 321895 ❌
/// 124578 ✅
/// 4.input จะต้องกันไม่ให้มีเลขชุดซ้ำ เกิน 2 ชุด
/// 112233 ❌
/// 882211 ❌
/// 887712 ✅
bool validatePinCode({required int pinCode}) {
  final input = pinCode.toString();
  RegExp validateLength = RegExp(r".{6,}");
  RegExp isRepeating = RegExp(r"(\d)\1\1+");
  RegExp validateSequential = RegExp(
      r"012|123|234|345|456|567|678|789|987|876|765|654|543|432|321|210|109");
  RegExp isRepeatingGroup = RegExp(r"(\d)\1+");
  return validateLength.hasMatch(input) &&
      !isRepeating.hasMatch(input) &&
      !validateSequential.hasMatch(input) &&
      isRepeatingGroup.allMatches(input).length <= 2;
}

void main() {
  group('UniqueBy', () {
    test('input จะต้องมีความยาวมากกว่าหรือเท่ากับ 6 ตัวอักษร', () {
      final result1 = validatePinCode(pinCode: 17283);
      final result2 = validatePinCode(pinCode: 172839);
      expect(result1, false);
      expect(result2, true);
    });

    test('input จะต้องกันไม่ให้มีเลขซ้ำติดกันเกิน 2 ตัว', () {
      final result1 = validatePinCode(pinCode: 111822);
      final result2 = validatePinCode(pinCode: 112762);
      expect(result1, false);
      expect(result2, true);
    });

    test('input จะต้องกันไม่ให้มีเลขเรียงกันเกิน 2 ตัว', () {
      final result1 = validatePinCode(pinCode: 123743);
      final result2 = validatePinCode(pinCode: 321895);
      final result3 = validatePinCode(pinCode: 124578);
      expect(result1, false);
      expect(result2, false);
      expect(result3, true);
    });

    test('input จะต้องกันไม่ให้มีเลขชุดซ้ำ เกิน 2 ชุด', () {
      final result1 = validatePinCode(pinCode: 112233);
      final result2 = validatePinCode(pinCode: 882211);
      final result3 = validatePinCode(pinCode: 887712);
      expect(result1, false);
      expect(result2, false);
      expect(result3, true);
    });
  });
}
