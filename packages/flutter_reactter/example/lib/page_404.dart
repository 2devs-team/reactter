import 'package:flutter/material.dart';

class Page404 extends StatelessWidget {
  const Page404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "404",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("Page not found"),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/");
                  },
                  child: const Text("Go to Home"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
