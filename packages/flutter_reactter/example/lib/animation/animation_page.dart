import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'animation_context.dart';

class AnimationPage extends StatelessWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<AnimationContext>(
      () => AnimationContext(),
      builder: (animationContext, context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Animation"),
          ),
          body: Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                Builder(
                  builder: (context) {
                    context.watch<AnimationContext>(
                      (inst) => [inst.borderRadiusAnimation],
                    );

                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            animationContext.borderRadiusAnimation.value,
                      ),
                    );
                  },
                ),
                SizedBox.square(
                  dimension: 100,
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        context.watch<AnimationContext>(
                          (inst) => [inst.sizeAnimation],
                        );

                        return Container(
                          width: animationContext.sizeAnimation.value,
                          height: animationContext.sizeAnimation.value,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    context.watch<AnimationContext>(
                      (inst) => [inst.colorAnimation],
                    );

                    return Container(
                      width: 100,
                      height: 100,
                      color: animationContext.colorAnimation.value,
                    );
                  },
                ),
                SizedBox.square(
                  dimension: 100,
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        context.watch<AnimationContext>();

                        return Container(
                          width: animationContext.sizeAnimation.value,
                          height: animationContext.sizeAnimation.value,
                          decoration: BoxDecoration(
                            color: animationContext.colorAnimation.value,
                            borderRadius:
                                animationContext.borderRadiusAnimation.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: animationContext.togglePlayAllAnimations,
            child: Builder(
              builder: (context) {
                context.watch<AnimationContext>(
                  (inst) => [inst.isAllAnimationsPlaying],
                );

                if (animationContext.isAllAnimationsPlaying.value) {
                  return const Icon(Icons.pause);
                }

                return const Icon(Icons.play_arrow);
              },
            ),
          ),
        );
      },
    );
  }
}
