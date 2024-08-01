import 'package:flutter/material.dart';
import 'counter.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Counter(),
            const SizedBox(height: 8),
            FutureBuilder(
              future: Future.delayed(Duration(seconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }

                return const Counter(id: "counterLazy");
              },
            ),
          ],
        ),
      ),
    );
  }
}
