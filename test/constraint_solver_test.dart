import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('constraint satisfaction framework', () {
    test('hello world', () {
      check("Hello, World!").isNotNull();
    });
  });
}
