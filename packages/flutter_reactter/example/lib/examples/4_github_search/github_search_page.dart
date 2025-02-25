// ignore_for_file: undefined_hidden_name

import 'package:examples/examples/4_github_search/widgets/info_card.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_github_search/controllers/github_search_controller.dart';
import 'package:examples/examples/4_github_search/widgets/search_bar.dart';

class GithubSearchPage extends StatelessWidget {
  const GithubSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      GithubSearchController.new,
      builder: (context, githubSearchController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Github search"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SearchBar(
                  onSearch: githubSearchController.onSearch,
                ),
              ),
            ),
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Center(
              child: FittedBox(
                child: InfoCard(),
              ),
            ),
          ),
        );
      },
    );
  }
}
