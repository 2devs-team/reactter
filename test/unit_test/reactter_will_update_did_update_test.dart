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

  late final firstName = UseState<String>("Leo", didUpdate: changeUserName);
  late final lastName = UseState<String>("León", didUpdate: changeUserName);

  changeUserName(String prev, String next) {
    userName.value = firstName.value + lastName.value;
  }
}
