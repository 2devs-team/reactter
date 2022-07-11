import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'animation_context.dart';

class AnimationExample extends StatelessWidget {
  const AnimationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => AnimationContext(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Animation"),
          ),
          body: Center(
            child: Wrap(
              spacing: 16,
              alignment: WrapAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox.square(
                  dimension: 100,
                  child: Center(
                    child: ReactterBuilder<AnimationContext>(
                      listenHooks: (ctx) => [ctx.sizeAnimation],
                      builder: (aniContext, context, child) {
                        return Container(
                          width: aniContext.sizeAnimation.value,
                          height: aniContext.sizeAnimation.value,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ReactterBuilder<AnimationContext>(
                  listenHooks: (ctx) => [ctx.borderRadiusAnimation],
                  builder: (aniContext, context, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: aniContext.borderRadiusAnimation.value,
                      ),
                    );
                  },
                ),
                ReactterBuilder<AnimationContext>(
                  listenHooks: (ctx) => [ctx.colorAnimation],
                  builder: (aniContext, context, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: aniContext.colorAnimation.value,
                    );
                  },
                ),
                SizedBox.square(
                  dimension: 100,
                  child: Center(
                    child: ReactterBuilder<AnimationContext>(
                      listenHooks: (ctx) => [
                        ctx.sizeAnimation,
                        ctx.borderRadiusAnimation,
                        ctx.colorAnimation
                      ],
                      builder: (aniContext, context, child) {
                        return Container(
                          width: aniContext.sizeAnimation.value,
                          height: aniContext.sizeAnimation.value,
                          decoration: BoxDecoration(
                            borderRadius:
                                aniContext.borderRadiusAnimation.value,
                            color: aniContext.colorAnimation.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
