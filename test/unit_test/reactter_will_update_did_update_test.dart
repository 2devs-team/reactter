import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

void main() {
  test(
    'GIVEN user with username LeoLeón WHEN new firstName is setted to Carlos THEN username is CarlosLeón',
    () {
      // ARRANGE
      final user = User();

      // ACT
      user.firstName.value = "Carlos";

      // ASSERT
      expect(user.userName.value, "CarlosLeón");

      // ACT
      user.lastName.value = "Cast";

      // ASSERT
      expect(user.userName.value, "CarlosCast");
    },
  );
}

class User {
  final userName = UseState<String>("LeoLeón");
  late final firstName = UseState<String>("Leo");
  late final lastName = UseState<String>("León");

  User() {
    firstName.onDidUpdate(changeUserName);
    lastName.onDidUpdate(changeUserName);
  }

  changeUserName() {
    userName.value = firstName.value + lastName.value;
  }
}
