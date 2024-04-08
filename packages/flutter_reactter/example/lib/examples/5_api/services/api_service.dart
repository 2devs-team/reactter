import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:examples/examples/5_api/models/repository.dart';
import 'package:examples/examples/5_api/models/user.dart';

typedef NotFoundException = Exception;

class ApiService {
  Future<Object?> getEntity(String query) async {
    final queryPath = query.split("/");

    if (queryPath.length > 1) {
      return await getRepository(queryPath[0], queryPath[1]);
    }

    return await getUser(query);
  }

  Future<User> getUser(String query) async {
    final response =
        await http.get(Uri.parse('https://api.github.com/users/$query'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    }

    throw Exception('Failed to load user');
  }

  Future<Repository> getRepository(String owner, String repo) async {
    final response =
        await http.get(Uri.parse('https://api.github.com/repos/$owner/$repo'));

    if (response.statusCode == 200) {
      return Repository.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      throw NotFoundException('Repository not found');
    }

    throw Exception('Failed to load repository');
  }
}
