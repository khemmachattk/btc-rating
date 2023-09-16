import 'package:flutter_test/flutter_test.dart';

/// เขียนโค้ดในการ filter array จาก array ของตัวเลข 2 ชุด
/// โดยให้สมาชิกของ array ชุดแรก เหลือเพียงแค่สมาชิกที่มีอยู่ใน array ชุดที่สองเท่านั้น
/// โดยห้ามใช้ function ที่มีอยู่ เช่น map, filter, contain, etc.
List<int> uniqueBy({required List<int> array1, required List<int> array2}) {
  final result = <int>[];
  final mapping = {};
  for (final item in array1) {
    mapping[item] = true;
  }
  for (final item in array2) {
    if (mapping[item] == true) {
      result.add(item);
    }
  }
  return result;
}

void main() {
  group('UniqueBy', () {
    test('must correctly case #1', () {
      final result = uniqueBy(
        array1: [10, 9, 8, 4, 5, 6, 7, 8, 1, 100],
        array2: [4, 5, 10],
      );
      expect(result, [4, 5, 10]);
    });

    test('must correctly case #2', () {
      final result = uniqueBy(
        array1: [1, 5, 8, 8, 8, 8, 2],
        array2: [4, 5, 10],
      );
      expect(result, [5]);
    });

    test('must correctly case #3', () {
      final result = uniqueBy(
        array1: [8],
        array2: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      );
      expect(result, [8]);
    });
  });
}
