import 'package:examples/examples/4_github_search/controllers/github_search_controller.dart';
import 'package:examples/examples/4_github_search/models/repository.dart';
import 'package:examples/examples/4_github_search/models/user.dart';
import 'package:examples/examples/4_github_search/utils/http_response.dart';
import 'package:examples/examples/4_github_search/widgets/repository_info.dart';
import 'package:examples/examples/4_github_search/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        width: 400,
        child: RtConsumer<GithubSearchController>(
          listenStates: (inst) => [inst.uEntity],
          builder: (_, githubSearchController, ___) {
            return githubSearchController.uEntity.when<Widget>(
              idle: (_) {
                return const Text(
                  'Search a user or repository(like "flutter/flutter")',
                );
              },
              loading: (_) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              done: (entity) {
                if (entity is User) {
                  return UserInfo(user: entity);
                }

                if (entity is Repository) {
                  return RepositoryInfo(repository: entity);
                }

                return const Text("Not found");
              },
              error: (error) {
                if (error is NotFoundException) {
                  return Text(
                    'Not found "${githubSearchController.query}"',
                  );
                }

                return Text(error.toString());
              },
            ) as Widget;
          },
        ),
      ),
    );
  }
}
