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
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
                            borderRadius:
                                animationContext.borderRadiusAnimation.value,
                            color: animationContext.colorAnimation.value,
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
