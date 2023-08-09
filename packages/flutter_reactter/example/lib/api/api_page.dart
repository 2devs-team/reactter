import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/api_controller.dart';
import 'models/repository.dart';
import 'models/user.dart';
import 'widgets/repository_item.dart';
import 'widgets/user_item.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<ApiController>(
      () => ApiController(),
      builder: (apiController, context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Github search"),
          ),
          body: Column(
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: apiController.formKey,
                            child: TextFormField(
                              autofocus: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Type a username or company name or'
                                    ' repository name("2devs-team/reactter")',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              maxLength: 150,
                              controller: apiController.textController,
                              focusNode: apiController.textFocusNode,
                              validator: apiController.validator,
                              onFieldSubmitted: (_) => apiController.search(),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            constraints: const BoxConstraints.tightFor(
                              width: 62,
                              height: 62,
                            ),
                            color: Colors.blueAccent,
                            icon: const Icon(Icons.search),
                            iconSize: 32,
                            padding: EdgeInsets.zero,
                            splashRadius: 24,
                            onPressed: apiController.search,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ReactterConsumer<ApiController>(
                listenStates: (inst) => [inst.entity],
                builder: (_, __, ___) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: apiController.entity.when<Widget>(
                      loading: (_) => const CircularProgressIndicator(),
                      done: (entity) => entity is User
                          ? UserItem(user: entity)
                          : RepositoryItem(repository: entity as Repository),
                      error: (_) => const Text("Not found"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
