// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/test_controllers.dart';

void main() {
  group("Obj", () {
    test("should be created by any type value", () {
      final objBool = Obj(true);
      expect(objBool, isA<Obj<bool>>());
      expect(objBool.value, true);
      expect("$objBool", true.toString());

      final objInt = Obj(1);
      expect(objInt, isA<Obj<int>>());
      expect(objInt.value, 1);
      expect("$objInt", 1.toString());

      final objDouble = Obj(1.2);
      expect(objDouble, isA<Obj<double>>());
      expect(objDouble.value, 1.2);
      expect("$objDouble", 1.2.toString());

      final objString = Obj("test");
      expect(objString, isA<Obj<String>>());
      expect(objString.value, "test");

      final objList = Obj(["test"]);
      expect(objList, isA<Obj<List<String>>>());
      expect(objList.value.first, "test");
      expect("$objList", ["test"].toString());

      final objMap = Obj({"test": 1});
      expect(objMap, isA<Obj<Map<String, int>>>());
      expect(objMap["test"], 1);
      expect("$objMap", {"test": 1}.toString());

      final objAnother = Obj(TestClass("test"));
      expect(objAnother, isA<Obj<TestClass>>());
      expect(objAnother.value.prop, "test");
      expect("$objAnother", TestClass("test").toString());

      final objNull = Obj<TestClass?>(null);
      expect(objNull, isA<Obj<TestClass?>>());
      expect(objNull.value, null);
      expect("$objNull", null.toString());
    });

    test("should set a new value", () {
      final objBool = Obj(true);
      objBool.value = false;
      expect(objBool.value, false);
      expect(objBool(true), true);

      final objInt = Obj(1);
      objInt.value = 2;
      expect(objInt.value, 2);
      expect(objInt(3), 3);

      final objDouble = Obj(1.2);
      objDouble.value = 2.3;
      expect(objDouble.value, 2.3);
      expect(objDouble(3.4), 3.4);

      final objString = Obj("test");
      objString.value = "other value";
      expect(objString.value, "other value");
      expect(objString("other value by call"), "other value by call");

      final objList = Obj(["test"]);
      objList.value = ["other value"];
      expect(objList.value.first, "other value");
      expect(objList(["other value by call"]).first, "other value by call");

      final objMap = Obj({"test": 1});
      objMap.value = {"other": 2};
      expect(objMap["other"], 2);
      expect(objMap({"other by call": 3})["other by call"], 3);

      final objAnother = Obj(TestClass("test"));
      objAnother.value = TestClass("other instance");
      expect(objAnother.value.prop, "other instance");
      expect(objAnother(TestClass("other instance by call")).prop,
          "other instance by call");

      final objNull = Obj<TestClass?>(null);
      objNull.value = TestClass("not null");
      expect(objNull.value?.prop, "not null");
      expect(objNull(TestClass("not null by call"))?.prop, "not null by call");
    });

    test("should be compared to another for its value", () {
      final objBool = Obj(true);
      expect(objBool == true, true);
      expect(objBool == Obj(true), true);

      final objInt = Obj(1);
      expect(objInt == 1, true);
      expect(objInt == Obj(1), true);

      final objDouble = Obj(1.2);
      expect(objDouble == 1.2, true);
      expect(objDouble == Obj(1.2), true);

      final objString = Obj("test");
      expect(objString == "test", true);
      expect(objString == Obj("test"), true);

      final objList = Obj(["test"]);
      expect(objList == ["test"], false);
      expect(objList == Obj(["test"]), false);

      final objMap = Obj({"test": 1});
      expect(objMap == {"test": 1}, false);
      expect(objMap == Obj({"test": 1}), false);

      final objAnother = Obj(TestClass("test"));
      expect(objAnother == TestClass("test"), false);
      expect(objAnother == Obj(TestClass("test")), false);

      final objNull = Obj<TestClass?>(null);
      expect(objNull == null, false);
      expect(objNull == Obj(null), true);
    });

    test("should be cast away nullability", () {
      final objNull = Obj<bool?>(true);
      expect(objNull.value, true);
      expect(objNull.notNull, isA<Obj<bool>>());
    });
  });
}
