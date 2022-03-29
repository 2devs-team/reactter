// ignore_for_file: avoid_print

import 'package:example/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/utils/helpers/reactter_future_helper.dart';

class Global {
  static final currentUser = UseState<User?>(null);
}

class UserContext extends ReactterContext {
  late final data = UseState<String?>(null, context: this);

  late final userName =
      UseAsyncState<String>("My username", fillUsername, context: this);

  Future<String> fillUsername() async {
    await delay(2000);

    print("->>> useState");

    return "Username filled";
  }

  loadData() {
    print("->>> loadData");

    print("->>> finish loadData");
    data.value = "Data filled!";
  }

  loadUserName() async {
    await userName.resolve();
  }

  @override
  awake() {
    print("->>> awake");
    loadData();
  }

  @override
  willMount() {
    print("->>> willMount");
  }

  @override
  didMount() {
    print("->>> didMount");
  }

  @override
  willUnmount() {
    print("->>> willUnmount");
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
        final userConsumer = context.of<UserContext>();

        print("Main builder");
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
                  standby: (value) => Text("Standby: " + value),
                  loading: () => const CircularProgressIndicator(),
                  done: (value) => Text(value),
                  error: (error) => const Text(
                    "Ha ocurrido un error al completar la solicitud",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                userConsumer.data.value == null
                    ? const CircularProgressIndicator()
                    : Text(userConsumer.data.value ?? '')
              ],
            ),
          ),
        );
      },
    );
  }
}
