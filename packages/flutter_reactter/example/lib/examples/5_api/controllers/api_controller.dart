import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_api/services/api_service.dart';

class ApiController {
  String _query = '';
  String get query => _query;

  final uEntity = UseAsyncState.withArg(
    null,
    Memo.inline<Future<Object?>, String>(
      ApiService().getEntity,
      const MemoInterceptors([
        AsyncMemoSafe(),
        TemporaryCacheMemo(Duration(seconds: 30)),
      ]),
    ),
  );

  void search(String query) {
    _query = query;
    uEntity.resolve(query);
  }
}
