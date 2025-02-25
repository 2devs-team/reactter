import 'dart:convert';

import 'package:examples/examples/4_github_search/providers/github_provider.dart';
import 'package:examples/examples/4_github_search/utils/http_response.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_github_search/models/repository.dart';
import 'package:examples/examples/4_github_search/models/user.dart';

class GithubRepository {
  final uGithubProvider = UseDependency.create(GithubProvider.new);

  GithubProvider get _githubProvider {
    return uGithubProvider.instance ?? (throw Exception('ApiProvider not found'));
  }

  Future<User> getUser(String query) async {
    return getResponse(
      request: _githubProvider.getUser(query),
      onSuccess: (response) => User.fromJson(jsonDecode(response.body)),
    );
  }

  Future<Repository> getRepository(String owner, String repo) async {
    return getResponse(
      request: _githubProvider.getRepository(owner, repo),
      onSuccess: (response) => Repository.fromJson(jsonDecode(response.body)),
    );
  }
}
