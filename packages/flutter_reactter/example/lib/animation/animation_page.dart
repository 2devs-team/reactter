import 'package:flutter/material.dart' hide AnimationController;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'animation_controller.dart';

class AnimationPage extends StatelessWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<AnimationController>(
      () => AnimationController(),
      builder: (animationController, context, child) {
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
                ReactterConsumer<AnimationController>(
                  listenStates: (inst) => [inst.borderRadiusAnimation],
                  builder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            animationController.borderRadiusAnimation.value,
                      ),
                    );
                  },
                ),
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: ReactterConsumer<AnimationController>(
                    listenStates: (inst) => [inst.sizeAnimation],
                    builder: (_, __, ___) {
                      return Container(
                        width: animationController.sizeAnimation.value,
                        height: animationController.sizeAnimation.value,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
                ReactterConsumer<AnimationController>(
                  listenStates: (inst) => [inst.colorAnimation],
                  builder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: animationController.colorAnimation.value,
                    );
                  },
                ),
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: ReactterConsumer<AnimationController>(
                    listenAll: true,
                    builder: (_, __, ___) {
                      return Container(
                        width: animationController.sizeAnimation.value,
                        height: animationController.sizeAnimation.value,
                        decoration: BoxDecoration(
                          color: animationController.colorAnimation.value,
                          borderRadius:
                              animationController.borderRadiusAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: animationController.togglePlayAllAnimations,
            child: ReactterConsumer<AnimationController>(
              listenStates: (inst) => [inst.isAllAnimationsPlaying],
              builder: (_, __, ___) {
                if (animationController.isAllAnimationsPlaying.value) {
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
