import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class UseAsyncStateBuilder extends StatelessWidget {
  final UseAsyncState state;
  const UseAsyncStateBuilder({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: state.when(
          standby: (state) => Text(state),
          loading: () => const Text("loading"),
          done: (state) => Text(state),
          error: (error) => Text(error.toString()),
        ),
      ),
    );
  }
}
