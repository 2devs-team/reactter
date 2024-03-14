import 'package:examples/animation/use_animation.dart';
import 'package:flutter/material.dart' hide AnimationController;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'animation_controller.dart';

class AnimationPage extends StatelessWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      AnimationController.new,
      builder: (context, animationController, child) {
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
                  listenStates: (inst) => [inst.uBorderRadiusAnimation],
                  builder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            animationController.uBorderRadiusAnimation.value,
                      ),
                    );
                  },
                ),
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: ReactterConsumer<AnimationController>(
                    listenStates: (inst) => [inst.uSizeAnimation],
                    builder: (_, __, ___) {
                      return Container(
                        width: animationController.uSizeAnimation.value,
                        height: animationController.uSizeAnimation.value,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
                ReactterConsumer<AnimationController>(
                  listenStates: (inst) => [inst.uColorAnimation],
                  builder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: animationController.uColorAnimation.value,
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
                        width: animationController.uSizeAnimation.value,
                        height: animationController.uSizeAnimation.value,
                        decoration: BoxDecoration(
                          color: animationController.uColorAnimation.value,
                          borderRadius:
                              animationController.uBorderRadiusAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ReactterSelector<AnimationController, bool>(
            selector: (inst, $) => [
              $(inst.uSizeAnimation.uControl).value,
              $(inst.uBorderRadiusAnimation.uControl).value,
              $(inst.uColorAnimation.uControl).value,
            ].every(
              (control) => ![
                AnimationControl.pause,
                AnimationControl.stop,
              ].contains(control),
            ),
            builder: (_, __, isPlaying, ___) {
              if (!isPlaying) {
                return FloatingActionButton(
                  heroTag: 'playButton',
                  onPressed: animationController.resumeAnimation,
                  child: const Icon(Icons.play_arrow),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'stopButton',
                    backgroundColor: Colors.red,
                    onPressed: animationController.stopAnimation,
                    child: const Icon(Icons.stop),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    heroTag: 'pauseButton',
                    onPressed: animationController.pauseAnimation,
                    child: const Icon(Icons.pause),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
