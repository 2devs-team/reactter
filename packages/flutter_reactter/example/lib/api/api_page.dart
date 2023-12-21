import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/api_controller.dart';
import 'models/repository.dart';
import 'models/user.dart';
import 'services/api_service.dart';
import 'widgets/repository_item.dart';
import 'widgets/search_bar.dart';
import 'widgets/user_item.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      ApiController.new,
      builder: (apiController, context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Github search"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8)
                    .copyWith(bottom: 2),
                child: SearchBar(
                  onSearch: apiController.search,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: ReactterConsumer<ApiController>(
                listenStates: (inst) => [inst.uEntity],
                builder: (_, __, ___) {
                  return FittedBox(
                    child: SizedBox(
                      width: 400,
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: apiController.uEntity.when<Widget>(
                            standby: (_) => const Text(
                              'Search a user or repository(like "flutter/flutter")',
                            ),
                            loading: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            done: (entity) {
                              if (entity is User) {
                                return UserItem(user: entity);
                              }

                              if (entity is Repository) {
                                return RepositoryItem(repository: entity);
                              }

                              return const Text("Not found");
                            },
                            error: (error) {
                              if (error is NotFoundException) {
                                return Text(
                                  'Not found "${apiController.query}"',
                                );
                              }

                              return Text(error.toString());
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
