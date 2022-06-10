import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'animation_context.dart';

class AnimationExample extends StatelessWidget {
  const AnimationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(
          () => AnimationContext(),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Animation"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReactterBuilder<AnimationContext>(
                  listenHooks: (ctx) => [ctx.animation],
                  builder: (aniContext, context, child) {
                    return Container(
                      width: aniContext.animation.value,
                      height: aniContext.animation.value,
                      color: Colors.blue,
                    );
                  },
                ),
                ReactterBuilder<AnimationContext>(
                  listenHooks: (ctx) => [ctx.animation2],
                  builder: (aniContext, context, child) {
                    return Container(
                      width: aniContext.animation2.value,
                      height: aniContext.animation2.value,
                      color: Colors.red,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
