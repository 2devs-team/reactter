import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/repository.dart';

class RepositoryContext extends ReactterContext {
  late final repository = UseState<Repository?>(null, this);

  RepositoryContext();
}
