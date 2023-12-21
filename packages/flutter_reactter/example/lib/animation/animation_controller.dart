import 'package:flutter/material.dart';

import 'use_animation.dart';

class AnimationController {
  final uSizeAnimation = UseAnimation<double>(
    AnimationOptions(
      tween: Tween(begin: 10, end: 100),
      duration: const Duration(milliseconds: 800),
      control: AnimationControl.mirror,
      curve: Curves.easeOut,
    ),
  );

  final uBorderRadiusAnimation = UseAnimation<BorderRadius?>(
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

  final uColorAnimation = UseAnimation<Color?>(
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

  void resumeAnimation() {
    uSizeAnimation.mirror();
    uBorderRadiusAnimation.mirror();
    uColorAnimation.mirror();
  }

  void pauseAnimation() {
    uSizeAnimation.pause();
    uBorderRadiusAnimation.pause();
    uColorAnimation.pause();
  }

  void stopAnimation() {
    uSizeAnimation.stop();
    uBorderRadiusAnimation.stop();
    uColorAnimation.stop();
  }
}
