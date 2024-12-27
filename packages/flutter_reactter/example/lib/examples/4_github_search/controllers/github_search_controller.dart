import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_github_search/repositories/github_repository.dart';

class GithubSearchController {
  String _query = '';
  String get query => _query;

  final uGithubRepository = UseDependency.create(GithubRepository.new);

  GithubRepository get githubRepository =>
      uGithubRepository.instance ??
      (throw Exception('GithubRepository not found'));

  late final uEntity = Rt.lazyState(() {
    final getEntityMemo = Memo.inline<Future<Object?>, String>(
      _getEntity,
      const MemoMultiInterceptor([
        MemoSafeAsyncInterceptor(),
        MemoTemporaryCacheInterceptor(Duration(seconds: 30)),
      ]),
    );

    return UseAsyncState.withArg(getEntityMemo, null);
  }, this);

  Future<Object?> _getEntity(String query) async {
    final queryPath = query.split("/");

    if (queryPath.length > 1) {
      final owner = queryPath.first;
      final repo = queryPath.last;

      return await githubRepository.getRepository(owner, repo);
    }

    return await githubRepository.getUser(query);
  }

  void onSearch(String query) {
    _query = query;
    uEntity.resolve(query);
  }
}
