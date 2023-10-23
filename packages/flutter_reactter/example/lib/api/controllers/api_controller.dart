import 'package:flutter_reactter/flutter_reactter.dart';

import '../services/api_service.dart';

class ApiController {
  String _query = '';
  String get query => _query;

  final entityState = UseAsyncState.withArg(
    null,
    Memo.inline<Future<Object?>, Args1<String>>(
      ApiService().getEntity.ary,
      const MemoInterceptors([
        AsyncMemoSafe(),
        TemporaryCacheMemo(Duration(seconds: 30)),
      ]),
    ),
  );

  void search(String query) {
    _query = query;
    entityState.resolve(Args1(query));
  }
}
