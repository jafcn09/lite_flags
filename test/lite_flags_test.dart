import 'package:test/test.dart';
import 'package:lite_flags/lite_flags.dart';

void main() {
  setUp(() => LiteFlags().clear());

  test('set and get local flag', () {
    LiteFlags().set('debug', true);
    expect(LiteFlags().get<bool>('debug', false), isTrue);
  });

  test('get returns default when flag not set', () {
    expect(LiteFlags().get<int>('missing', 42), equals(42));
  });

  test('isEnabled returns false for unset flag', () {
    expect(LiteFlags().isEnabled('unknown'), isFalse);
  });

  test('isEnabled returns true for enabled flag', () {
    LiteFlags().set('feature_x', true);
    expect(LiteFlags().isEnabled('feature_x'), isTrue);
  });

  test('load parses JSON from loader', () async {
    LiteFlags().setLoader((_) async => '{"remote_flag": true, "limit": 100}');
    await LiteFlags().load('https://mock.url');

    expect(LiteFlags().isEnabled('remote_flag'), isTrue);
    expect(LiteFlags().get<int>('limit', 0), equals(100));
  });

  test('load throws if loader not set', () async {
    LiteFlags().reset();
    await expectLater(LiteFlags().load('url'), throwsStateError);
  });

  test('clear removes all flags', () {
    LiteFlags().set('a', 1);
    LiteFlags().set('b', 2);
    LiteFlags().clear();
    expect(LiteFlags().get<int>('a', 0), equals(0));
    expect(LiteFlags().get<int>('b', 0), equals(0));
  });
}
