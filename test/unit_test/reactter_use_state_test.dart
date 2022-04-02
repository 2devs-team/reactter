import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

void main() {
  test(
    'GIVEN user with age 24 WHEN birthday is called THEN user is old',
    () {
      // ARRANGE
      final user = User();

      // ACT
      user.birthday();

      // ASSERT
      expect(user.age.value, 25);
    },
  );

  test(
    'GIVEN user with name Leo WHEN changeName is called THEN user name is the parameter value',
    () {
      // ARRANGE
      final user = User();

      // ACT
      const newName = "Carlos";
      user.changeName(newName);

      // ASSERT
      expect(user.name.value, newName);
    },
  );

  test(
    'GIVEN user with name Leo WHEN changeName and reset is called THEN user name is the default value: Leo',
    () {
      // ARRANGE
      final user = User();

      // ACT
      user.changeName("Carlos");
      user.name.reset();

      // ASSERT
      expect(user.name.value, "Leo");
    },
  );

  test(
    'GIVEN user with name Leo WHEN changeNameAsync THEN user name is Carlos',
    () async {
      // ARRANGE
      final user = User();

      // ACT
      await user.changeNameAsync();

      // ASSERT
      expect(user.name.value, "Carlos");
    },
  );
}

class User {
  final age = UseState<int>(24);
  final name = UseState<String>("Leo");

  void birthday() {
    age.value = age.value + 1;
  }

  void changeName(String newName) {
    name.value = newName;
  }

  Future<void> changeNameAsync() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    name.value = "Carlos";
  }
}
