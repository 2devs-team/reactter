import 'package:flutter_reactter/flutter_reactter.dart';

import '../services/api_service.dart';

class ApiController {
  String _query = '';
  String get query => _query;

  final entity = UseAsyncState.withArgs(
    null,
    Reactter.memo(ApiService().getEntity.ary),
  );

  void search(String query) {
    _query = query;
    entity.resolve(Args1(query));
  }
}
