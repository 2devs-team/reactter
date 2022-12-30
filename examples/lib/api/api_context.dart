import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'models/repository.dart';
import 'models/user.dart';

class ApiContext extends ReactterContext {
  final formKey = GlobalKey<FormState>();
  final textFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  late final entity =
      UseAsyncState<Object?, String>(null, _resolveEntity, this);

  String _input = "";

  ApiContext() {
    textController.addListener(() {
      _input = textController.text;
    });
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Can't be empty";
    }

    return null;
  }

  void search() async {
    entity.resolve(_input);
  }

  Future<Object?> _resolveEntity([String query = ""]) async {
    final queryPath = query.split("/");

    if (queryPath.length > 1) {
      return await _getRepository(queryPath[0], queryPath[1]);
    }

    return await _getUser(query);
  }

  Future<User> _getUser(String query) async {
    final response =
        await http.get(Uri.parse('https://api.github.com/users/$query'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Repository> _getRepository(String owner, String repo) async {
    final response =
        await http.get(Uri.parse('https://api.github.com/repos/$owner/$repo'));

    if (response.statusCode == 200) {
      return Repository.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load repo');
    }
  }
}
