import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'use_animation.dart';

class AnimationController {
  final sizeAnimation = UseAnimation<double>(
    AnimationOptions(
      tween: Tween(begin: 10, end: 100),
      duration: const Duration(milliseconds: 800),
      control: AnimationControl.mirror,
      curve: Curves.easeOut,
    ),
  );

  final borderRadiusAnimation = UseAnimation<BorderRadius?>(
    AnimationOptions(
      tween: BorderRadiusTween(
        begin: BorderRadius.circular(75.0),
        end: BorderRadius.circular(0.0),
      ),
      duration: const Duration(milliseconds: 600),
      control: AnimationControl.mirror,
      curve: Curves.easeOut,
    ),
  );

  final colorAnimation = UseAnimation<Color?>(
    AnimationOptions(
      tween: TweenSequence<Color?>(
        [
          TweenSequenceItem(
            weight: 1,
            tween: ColorTween(
              begin: Colors.red,
              end: Colors.blue,
            ),
          ),
          TweenSequenceItem(
            weight: 1,
            tween: ColorTween(
              begin: Colors.blue,
              end: Colors.green,
            ),
          ),
          TweenSequenceItem(
            weight: 1,
            tween: ColorTween(
              begin: Colors.green,
              end: Colors.yellow,
            ),
          ),
          TweenSequenceItem(
            weight: 1,
            tween: ColorTween(
              begin: Colors.yellow,
              end: Colors.red,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      control: AnimationControl.mirror,
      curve: Curves.easeInOut,
    ),
  );

  late final isAllAnimationsPlaying = Reactter.lazy(() {
    return UseCompute(
      () {
        return [
          sizeAnimation.control,
          borderRadiusAnimation.control,
          colorAnimation.control,
        ].every((control) => control.value != AnimationControl.stop);
      },
      [
        sizeAnimation.control,
        borderRadiusAnimation.control,
        colorAnimation.control,
      ],
    );
  }, this);

  void togglePlayAllAnimations() {
    if (isAllAnimationsPlaying.value) {
      sizeAnimation.stop();
      borderRadiusAnimation.stop();
      colorAnimation.stop();
      return;
    }

    sizeAnimation.mirror();
    borderRadiusAnimation.mirror();
    colorAnimation.mirror();
  }
}
