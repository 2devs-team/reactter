// ignore_for_file: unnecessary_null_comparison

import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_context.dart';

void main() {
  group("Obj", () {
    test("should be created by any type value", () {
      final objBool = true.obj;
      expect(objBool, isA<Obj<bool>>());
      expect(objBool.value, true);
      expect("${objBool}", true.toString());

      final objInt = 1.obj;
      expect(objInt, isA<Obj<int>>());
      expect(objInt.value, 1);
      expect("${objInt}", 1.toString());

      final objDouble = 1.2.obj;
      expect(objDouble, isA<Obj<double>>());
      expect(objDouble.value, 1.2);
      expect("${objDouble}", 1.2.toString());

      final objString = "test".obj;
      expect(objString, isA<Obj<String>>());
      expect(objString.value, "test");

      final objList = ["test"].obj;
      expect(objList, isA<Obj<List<String>>>());
      expect(objList.value.first, "test");
      expect("${objList}", ["test"].toString());

      final objMap = {"test": 1}.obj;
      expect(objMap, isA<Obj<Map<String, int>>>());
      expect(objMap["test"], 1);
      expect("${objMap}", {"test": 1}.toString());

      final objAnother = TestClass("test").obj;
      expect(objAnother, isA<Obj<TestClass>>());
      expect(objAnother.value.prop, "test");
      expect("${objAnother}", TestClass("test").toString());

      final objNull = Obj<TestClass?>(null);
      expect(objNull, isA<Obj<TestClass?>>());
      expect(objNull.value, null);
      expect("${objNull}", null.toString());
    });

    test("should set a new value", () {
      final objBool = true.obj;
      objBool.value = false;
      expect(objBool.value, false);
      expect(objBool(true), true);

      final objInt = 1.obj;
      objInt.value = 2;
      expect(objInt.value, 2);
      expect(objInt(3), 3);

      final objDouble = 1.2.obj;
      objDouble.value = 2.3;
      expect(objDouble.value, 2.3);
      expect(objDouble(3.4), 3.4);

      final objString = "test".obj;
      objString.value = "other value";
      expect(objString.value, "other value");
      expect(objString("other value by call"), "other value by call");

      final objList = ["test"].obj;
      objList.value = ["other value"];
      expect(objList.value.first, "other value");
      expect(objList(["other value by call"]).first, "other value by call");

      final objMap = {"test": 1}.obj;
      objMap.value = {"other": 2};
      expect(objMap["other"], 2);
      expect(objMap({"other by call": 3})["other by call"], 3);

      final objAnother = TestClass("test").obj;
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
      final objBool = true.obj;
      expect(objBool == true, true);
      expect(objBool == true.obj, true);

      final objInt = 1.obj;
      expect(objInt == 1, true);
      expect(objInt == 1.obj, true);

      final objDouble = 1.2.obj;
      expect(objDouble == 1.2, true);
      expect(objDouble == 1.2.obj, true);

      final objString = "test".obj;
      expect(objString == "test", true);
      expect(objString == "test".obj, true);

      final objList = ["test"].obj;
      expect(objList == ["test"], false);
      expect(objList == ["test"].obj, false);

      final objMap = {"test": 1}.obj;
      expect(objMap == {"test": 1}, false);
      expect(objMap == {"test": 1}.obj, false);

      final objAnother = TestClass("test").obj;
      expect(objAnother == TestClass("test"), false);
      expect(objAnother == TestClass("test").obj, false);

      final objNull = Obj<TestClass?>(null);
      expect(objNull == null, false);
      expect(objNull == null.obj, true);
    });

    test("should be cast away nullability", () {
      final objNull = Obj<bool?>(true);
      expect(objNull.value, true);
      expect(objNull.notNull, isA<Obj<bool>>());
    });
  });
}
