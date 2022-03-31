// ignore_for_file: avoid_print

import 'package:example/data/models/mocks.dart';
import 'package:example/data/models/user.dart';
import 'package:example/testing_cases/user_view.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class Global {
  static final currentUser = UseState<User?>(null);
}

class UserContext extends ReactterContext {
  final users = Mocks.getUsers();

  onClickUser(BuildContext context, int index) {
    Global.currentUser.value = users![index];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserView()),
    );
  }
}

class UseEffectExample extends StatelessWidget {
  const UseEffectExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => UserContext(),
          init: true,
        ),
      ],
      builder: (context, _) {
        final useContext = context.of<UserContext>();

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
                Text("Users: ${useContext.users!.length}"),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: useContext.users!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = useContext.users![index];

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
                            onPressed: () {
                              useContext.onClickUser(context, index);
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
