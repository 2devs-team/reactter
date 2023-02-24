import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'api_context.dart';
import 'models/repository.dart';
import 'models/user.dart';
import 'repository_item.dart';
import 'user_item.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<ApiContext>(
      () => ApiContext(),
      builder: (apiContext, context, child) {
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
                            key: apiContext.formKey,
                            child: TextFormField(
                              controller: apiContext.textController,
                              validator: apiContext.validator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.sentences,
                              autofocus: true,
                              focusNode: apiContext.textFocusNode,
                              maxLength: 150,
                              onFieldSubmitted: (_) => apiContext.search(),
                              decoration: const InputDecoration(
                                labelText:
                                    'Type a username or company name or repository name("2devs-team/reactter")',
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: apiContext.search,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 62,
                              height: 62,
                            ),
                            splashRadius: 24,
                            iconSize: 32,
                            color: Colors.blueAccent,
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  context.watch<ApiContext>((ctx) => [ctx.entity]);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: apiContext.entity.when<Widget>(
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
