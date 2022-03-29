// ignore_for_file: avoid_print

import 'package:example/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/utils/helpers/reactter_future_helper.dart';

class Global {
  static final currentUser = UseState<User?>(null);
}

class UserContext extends ReactterContext {
  final data = UseState<String?>(null);

  late final userName =
      UseAsyncState<String?>(null, fillUsername, context: this);

  Future<String> fillUsername() async {
    await delay(2000);

    return "Leoocast";
  }

  Future<void> loadData() async {
    await delay(2000);
    data.value = "Data filled!";
  }

  loadUserName() async {
    await userName.resolve();
  }
}

class UseFutureExample extends StatelessWidget {
  const UseFutureExample({Key? key}) : super(key: key);

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
        final userConsumer = context.$<UserContext>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter UseFuture"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: userConsumer.loadUserName,
                  child: const Text("Load username"),
                ),
                const SizedBox(
                  height: 15,
                ),
                userConsumer.userName.when(
                  standby: () => const Text("Wating for load"),
                  loading: () => const CircularProgressIndicator(),
                  done: (value) => Text(value!),
                ),
                // UseFuture<String>(
                //   watch: userConsumer.data,
                //   future: userConsumer.loadData(),
                //   isWaiting: () => const CircularProgressIndicator(),
                //   isDone: (value) => Text(value),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
