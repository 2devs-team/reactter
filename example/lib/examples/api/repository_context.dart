import 'package:reactter/reactter.dart';

import 'repository.dart';

class RepositoryContext extends ReactterContext {
  late final repository = UseState<Repository?>(null, this);

  RepositoryContext();
}
