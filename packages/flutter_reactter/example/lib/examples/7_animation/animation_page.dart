import 'package:flutter/material.dart' hide AnimationController;
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/7_animation/controllers/animation_controller.dart';

class AnimationPage extends StatelessWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
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
                RtSelector<AnimationController, bool>(
                  selector: (inst, $) {
                    return inst.checkIfPlaying(
                      $(inst.uBorderRadiusAnimation.uControl).value,
                    );
                  },
                  child: RtConsumer<AnimationController>(
                    listenStates: (inst) => [inst.uBorderRadiusAnimation],
                    builder: (_, inst, ___) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: inst.uBorderRadiusAnimation.value,
                        ),
                      );
                    },
                  ),
                  builder: (context, inst, isPlaying, child) {
                    return AnimationContainer(
                      title: 'Radius',
                      isPlaying: isPlaying,
                      onPlayPress: inst.uBorderRadiusAnimation.resume,
                      onPausePress: inst.uBorderRadiusAnimation.pause,
                      child: child!,
                    );
                  },
                ),
                RtSelector<AnimationController, bool>(
                  selector: (inst, $) {
                    return inst.checkIfPlaying(
                      $(inst.uSizeAnimation.uControl).value,
                    );
                  },
                  child: RtConsumer<AnimationController>(
                    listenStates: (inst) => [inst.uSizeAnimation],
                    builder: (_, inst, ___) {
                      return Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        width: inst.uSizeAnimation.value,
                        height: inst.uSizeAnimation.value,
                      );
                    },
                  ),
                  builder: (context, inst, isPlaying, child) {
                    return AnimationContainer(
                      title: 'Size',
                      isPlaying: isPlaying,
                      onPlayPress: inst.uSizeAnimation.resume,
                      onPausePress: inst.uSizeAnimation.pause,
                      child: child!,
                    );
                  },
                ),
                RtSelector<AnimationController, bool>(
                  selector: (inst, $) {
                    return inst.checkIfPlaying(
                      $(inst.uColorAnimation.uControl).value,
                    );
                  },
                  child: RtConsumer<AnimationController>(
                    listenStates: (inst) => [inst.uColorAnimation],
                    builder: (_, inst, ___) {
                      return Container(
                        color: inst.uColorAnimation.value,
                      );
                    },
                  ),
                  builder: (context, inst, isPlaying, child) {
                    return AnimationContainer(
                      title: 'Color',
                      isPlaying: isPlaying,
                      onPlayPress: inst.uColorAnimation.resume,
                      onPausePress: inst.uColorAnimation.pause,
                      child: child!,
                    );
                  },
                ),
                RtSelector<AnimationController, bool>(
                  selector: (inst, $) {
                    return [
                      $(inst.uSizeAnimation.uControl).value,
                      $(inst.uBorderRadiusAnimation.uControl).value,
                      $(inst.uColorAnimation.uControl).value,
                    ].every(inst.checkIfPlaying);
                  },
                  child: RtConsumer<AnimationController>(
                    listenAll: true,
                    builder: (_, inst, ___) {
                      return Container(
                        width: inst.uSizeAnimation.value,
                        height: inst.uSizeAnimation.value,
                        decoration: BoxDecoration(
                          color: inst.uColorAnimation.value,
                          borderRadius: inst.uBorderRadiusAnimation.value,
                        ),
                      );
                    },
                  ),
                  builder: (context, inst, isPlaying, child) {
                    return AnimationContainer(
                      title: 'All',
                      isPlaying: isPlaying,
                      onPlayPress: inst.resumeAllAnimation,
                      onPausePress: inst.pauseAllAnimation,
                      child: child!,
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

class AnimationContainer extends StatelessWidget {
  const AnimationContainer({
    Key? key,
    required this.title,
    required this.child,
    this.isPlaying = false,
    this.onPlayPress,
    this.onPausePress,
  }) : super(key: key);

  final String title;
  final Widget child;
  final bool isPlaying;
  final void Function()? onPlayPress;
  final void Function()? onPausePress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              icon: isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              onPressed: isPlaying ? onPausePress : onPlayPress,
            ),
            Text(title),
          ],
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: child,
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(6),
      splashRadius: 18,
      iconSize: 24,
      constraints: const BoxConstraints.tightForFinite(),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
