import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GithubAPI {
  static const String _apiBaseUrl = 'api.github.com';

  Uri user(String username) {
    return _buildUri(endpoint: '/users/$username');
  }

  Uri repository(String owner, String repo) {
    return _buildUri(endpoint: '/repos/$owner/$repo');
  }

  Uri _buildUri({
    required String endpoint,
    Map<String, dynamic> Function()? parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: endpoint,
      queryParameters: parametersBuilder?.call(),
    );
  }
}

class GithubProvider {
  final GithubAPI _api = GithubAPI();
  final Client _client = http.Client();

  Future<Response> getUser(String username) {
    return _client.get(_api.user(username));
  }

  Future<Response> getRepository(String owner, String repo) {
    return _client.get(_api.repository(owner, repo));
  }
}
