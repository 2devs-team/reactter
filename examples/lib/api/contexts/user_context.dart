import 'package:reactter/reactter.dart';

import '../models/user.dart';

class UserContext extends ReactterContext {
  late final user = UseState<User?>(null, this);

  UserContext();
}
