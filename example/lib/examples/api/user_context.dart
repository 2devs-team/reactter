import 'package:reactter/reactter.dart';

import 'user.dart';

class UserContext extends ReactterContext {
  late final user = UseState<User?>(null, this);

  UserContext();
}
