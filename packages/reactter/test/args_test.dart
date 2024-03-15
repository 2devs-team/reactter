// ignore_for_file: avoid_shadowing_type_parameters

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

typedef AryFunctionType<T> = FutureOr<T> Function<T>(Args<dynamic> args);

void main() {
  group("Args", () {
    test("should be created without arguments", () {
      final args = Args();

      expect(args.arguments, isEmpty);
    });

    test("should be created with n arguments", () {
      final args = Args([1, 'test', false]);

      expect(args.arguments, [1, 'test', false]);

      expect(args.arg1, 1);
    });

    test("should convert the arguments to List by type", () {
      final args = Args([1, 'test', false]);

      expect(args.toList<String>(), isA<List<String>>());
      expect(args.toList<String>(), ['test']);
    });
  });
  test("Args1 should be created with an argument", () {
    final args = Args1(1);

    expect(args.arg1, 1);
    expect(args.arguments, [1]);
  });

  test("Args2 should be created with two arguments", () {
    final args = Args2(1, 'test');

    expect(args.arg1, 1);
    expect(args.arg2, 'test');
    expect(args.arguments, [1, 'test']);
  });

  test("Args3 should be created with three arguments", () {
    final args = Args3(1, 'test', true);

    expect(args.arg1, 1);
    expect(args.arg2, 'test');
    expect(args.arg3, true);
    expect(args.arguments, [1, 'test', true]);
  });

  test("ArgsX2 should be created with two arguments of the same type", () {
    final args = ArgsX2<double>(1, 2.5);

    expect(args.arg1, 1.0);
    expect(args.arg2, 2.5);
    expect(args.arg1, isA<double>());
    expect(args.arg2, isA<double>());
    expect(args.arguments, [1.0, 2.5]);
  });

  test("ArgsX3 should be created with two arguments of the same type", () {
    final args = ArgsX3<double>(1, 2.5, .3);

    expect(args.arg1, 1.0);
    expect(args.arg2, 2.5);
    expect(args.arg3, 0.3);
    expect(args.arg1, isA<double>());
    expect(args.arg2, isA<double>());
    expect(args.arg3, isA<double>());
    expect(args.arguments, [1.0, 2.5, 0.3]);
  });

  test("Function with an argument should ary using Args1", () {
    List<int> args1Fn(int arg1) {
      return [arg1];
    }

    expect(args1Fn.ary, isA<List<int> Function(Args1<int>)>());
    expect(args1Fn.ary(Args1(1)), [1]);
  });

  test("Function with two arguments should ary using Args2", () {
    List args2Fn(int arg1, String arg2) {
      return [arg1, arg2];
    }

    List args1_1Fn(int arg1, [String? arg2]) {
      return [arg1, arg2];
    }

    expect(args2Fn.ary, isA<List Function(Args2<int, String>)>());
    expect(args2Fn.ary(Args2(1, 'test')), [1, 'test']);

    expect(args1_1Fn.ary, isA<List Function(Args2<int, String?>)>());
    expect(args1_1Fn.ary(Args2(1, 'test')), [1, 'test']);
    expect(args1_1Fn.ary(Args2(1, null)), [1, null]);
  });

  test("Function with three arguments should ary using Args3", () {
    List args3Fn(int arg1, String arg2, bool arg3) {
      return [arg1, arg2, arg3];
    }

    List args2_1Fn(int arg1, String arg2, [bool? arg3]) {
      return [arg1, arg2, arg3];
    }

    List args1_2Fn(int arg1, [String? arg2, bool? arg3]) {
      return [arg1, arg2, arg3];
    }

    expect(args3Fn.ary, isA<List Function(Args3<int, String, bool>)>());
    expect(args3Fn.ary(Args3(1, 'test', true)), [1, 'test', true]);

    expect(args2_1Fn.ary, isA<List Function(Args3<int, String, bool?>)>());
    expect(args2_1Fn.ary(Args3(1, 'test', true)), [1, 'test', true]);
    expect(args2_1Fn.ary(Args3(1, 'test', null)), [1, 'test', null]);

    expect(args1_2Fn.ary, isA<List Function(Args3<int, String?, bool?>)>());
    expect(args1_2Fn.ary(Args3(1, 'test', true)), [1, 'test', true]);
    expect(args1_2Fn.ary(Args3(1, 'test', null)), [1, 'test', null]);
    expect(args1_2Fn.ary(Args3(1, null, null)), [1, null, null]);
  });

  test("Function with 4 or more arguments should ary using Args", () {
    List args4Fn(int arg1, String arg2, bool arg3, Symbol arg4) {
      return [arg1, arg2, arg3, arg4];
    }

    List args4_2Fn(
      int arg1,
      String arg2,
      bool arg3,
      Symbol arg4, [
      Symbol? arg5,
      Symbol? arg6,
    ]) {
      return [arg1, arg2, arg3, arg4, arg5, arg6];
    }

    expect(args4Fn.ary, isA<AryFunctionType>());
    expect(
      args4Fn.ary(Args([
        1,
        'test',
        true,
        Symbol('4'),
      ])),
      [
        1,
        'test',
        true,
        Symbol('4'),
      ],
    );

    expect(args4_2Fn.ary, isA<AryFunctionType>());
    expect(
      args4_2Fn.ary(Args([
        1,
        'test',
        true,
        Symbol('4'),
        Symbol('5'),
        Symbol('6'),
      ])),
      [
        1,
        'test',
        true,
        Symbol('4'),
        Symbol('5'),
        Symbol('6'),
      ],
    );
    expect(
      args4_2Fn.ary(Args([
        1,
        'test',
        true,
        Symbol('4'),
        Symbol('5'),
      ])),
      [
        1,
        'test',
        true,
        Symbol('4'),
        Symbol('5'),
        null,
      ],
    );
    expect(
      args4_2Fn.ary(Args([
        1,
        'test',
        true,
        Symbol('4'),
      ])),
      [
        1,
        'test',
        true,
        Symbol('4'),
        null,
        null,
      ],
    );
  });
}
