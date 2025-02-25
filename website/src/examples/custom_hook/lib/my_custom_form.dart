import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'my_controller.dart';

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider<MyController>(
      () => MyController(),
      builder: (context, myController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Custom hook example"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RtConsumer<MyController>(
                  listenStates: (myController) => [myController.fullName],
                  child: const Text(
                    "Full Name:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  builder: (context, myController, child) {
                    return Row(
                      children: [
                        child!,
                        const SizedBox(width: 4),
                        Text(myController.fullName.value),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "First Name",
                  ),
                  controller: myController.firstNameInput.controller,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Last Name",
                  ),
                  controller: myController.lastNameInput.controller,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
