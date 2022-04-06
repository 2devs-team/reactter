// ignore_for_file: avoid_print

import 'package:example/data/models/mocks.dart';
import 'package:example/data/models/user.dart';
import 'package:example/testing_cases/user_view.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class Global {
  static final currentUser = UseState<User?>(null);
}

class AppContext extends ReactterContext {
  final users = Mocks.getUsers();
  final usersVisited = UseState<int>(0);

  onClickUser(BuildContext context, int index) {
    Global.currentUser.value = users![index];
  }
}

class UseEffectExample extends StatelessWidget {
  const UseEffectExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
      ],
      builder: (context, _) {
        final appContext = context.of<AppContext>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter example"),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(appContext.userName.value),
                const SizedBox(height: 20),
                Text("Users: ${appContext.users!.length}"),
                const SizedBox(height: 20),
                Text("Users visited: ${appContext.usersVisited.value}"),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: appContext.users!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = appContext.users![index];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text('${user.firstName} ${user.lastName} '),
                          ),
                        ),
                        ElevatedButton(
                            key: Key('button_${user.firstName}'),
                            onPressed: () {
                              appContext.onClickUser(context, index);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserView(appContext)),
                              );
                            },
                            child: const Text("View"))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
