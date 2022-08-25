import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Group description', () {
    setUp(() {});
    test('Test 1 description', () {
      expect(1, 1);
    });
    test('Test 2 description', () {
      expect(1, 1);
    });
    tearDown(() {});
  });
  test('Test 3 description', () {
    expect(1, 1);
  });
}
