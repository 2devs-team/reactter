import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_api/services/api_service.dart';

class ApiController {
  final apiService = ApiService();

  String _query = '';
  String get query => _query;

  late final uEntity = Rt.lazyState(
    () => UseAsyncState.withArg(
      null,
      Memo.inline<Future<Object?>, String>(
        getEntity,
        const MemoMultiInterceptor([
          MemoSafeAsyncInterceptor(),
          MemoTemporaryCacheInterceptor(Duration(seconds: 30)),
        ]),
      ),
    ),
    this,
  );

  Future<Object?> getEntity(String query) async {
    final queryPath = query.split("/");

    if (queryPath.length > 1) {
      return await apiService.getRepository(queryPath[0], queryPath[1]);
    }

    return await apiService.getUser(query);
  }

  void search(String query) {
    _query = query;
    uEntity.resolve(query);
  }
}
