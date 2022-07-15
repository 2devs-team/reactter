import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/core.dart';

import '../shareds/test_context.dart';

void main() {
  group("ReactterInstanceManager", () {
    test("should register instance", () async {
      bool registered = Reactter.register(builder: () => TestContext());
      expect(registered, true);

      registered = Reactter.register(builder: () => TestContext());
      expect(registered, false);

      Reactter.unregister<TestContext>();
    });

    test("should register instance with id", () async {
      bool registered = Reactter.register(
        id: 'uniqueId',
        builder: () => TestContext(),
      );
      expect(registered, true);

      registered = Reactter.register(
        id: 'uniqueId',
        builder: () => TestContext(),
      );
      expect(registered, false);

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should unregister instance", () async {
      Reactter.register(builder: () => TestContext());

      bool unregistered = Reactter.unregister<TestContext>();
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestContext>();
      expect(unregistered, false);
    });

    test("should unregister instance with id", () async {
      Reactter.register(id: 'uniqueId', builder: () => TestContext());

      bool unregistered = Reactter.unregister<TestContext>('uniqueId');
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestContext>('uniqueId');
      expect(unregistered, false);
    });

    test("should get instance", () async {
      var instance = Reactter.get<TestContext>();
      expect(instance, null);

      Reactter.register(builder: () => TestContext());

      instance = Reactter.get<TestContext>();
      expect(instance, isInstanceOf<TestContext>());

      Reactter.unregister<TestContext>();
    });

    test("should get instance with id", () async {
      var instance = Reactter.get<TestContext>('uniqueId');
      expect(instance, null);

      Reactter.register(id: 'uniqueId', builder: () => TestContext());

      instance = Reactter.get<TestContext>('uniqueId');
      expect(instance, isInstanceOf<TestContext>());

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should create instance", () async {
      var instance = Reactter.create(builder: () => TestContext(), ref: 'key');

      expect(instance, isInstanceOf<TestContext>());

      Reactter.unregister<TestContext>();
    });

    test("should create instance with id", () async {
      final instance = Reactter.create(
          id: 'uniqueId', builder: () => TestContext(), ref: 'key');

      expect(instance, isInstanceOf<TestContext>());

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should delete instance", () async {
      Reactter.create(builder: () => TestContext(), ref: 'key');

      bool isDeleted = Reactter.delete<TestContext>(null, 'key');
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestContext>(null, 'key');
      expect(isDeleted, false);

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should create instance with id", () async {
      final instance = Reactter.create(
          id: 'uniqueId', builder: () => TestContext(), ref: 'key');

      expect(instance, isInstanceOf<TestContext>());

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should delete instance with id", () async {
      Reactter.create(id: 'uniqueId', builder: () => TestContext(), ref: 'key');

      bool isDeleted = Reactter.delete<TestContext>('uniqueId', 'key');
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestContext>('uniqueId', 'key');
      expect(isDeleted, false);

      Reactter.unregister<TestContext>('uniqueId');
    });

    test("should find instance", () async {
      var reactterInstance = Reactter.find(TestContext());
      expect(reactterInstance, null);

      final instance = Reactter.create(builder: () => TestContext());

      reactterInstance = Reactter.find(instance);
      expect(reactterInstance, isInstanceOf<ReactterInstance>());

      Reactter.unregister<TestContext>();
    });

    test("should check if exist the instance", () async {
      bool isExistInstance = Reactter.exists<TestContext>();
      expect(isExistInstance, false);

      Reactter.create(builder: () => TestContext());
      isExistInstance = Reactter.exists<TestContext>();
      expect(isExistInstance, true);
    });

    test("should check if exist the instance with id", () async {
      bool isExistInstance = Reactter.exists<TestContext>('uniqueId');
      expect(isExistInstance, false);

      Reactter.create(id: 'uniqueId', builder: () => TestContext());
      isExistInstance = Reactter.exists<TestContext>('uniqueId');
      expect(isExistInstance, true);
    });
  });
}
