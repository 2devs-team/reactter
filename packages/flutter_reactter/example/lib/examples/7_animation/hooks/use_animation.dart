import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

/// Defines different control options for playing an animation. Each option
/// represents a specific behavior for the animation playback:
enum AnimationControl {
  /// Plays the animation from the current position to the end.
  play,

  /// Plays the animation from the current position reverse to the start.
  playReverse,

  /// Reset the position of the animation to `0.0` and starts playing
  /// to the end.
  playFromStart,

  /// Reset the position of the animation to `1.0` and starts playing
  /// reverse to the start.
  playReverseFromEnd,

  /// Endlessly plays the animation from the start to the end.
  loop,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  mirror,

  /// Stops the animation at the current position.
  pause,

  /// Stops and resets animation.
  stop,
}

/// The `AnimationOptions` class represents the options for an animation,
/// including the tween, duration, control, curve, start position,
/// frames per second, delay, and animation status listener.
class AnimationOptions<T> {
  final Animatable<T> tween;
  final Duration duration;
  final AnimationControl control;
  final Curve curve;
  final double startPosition;
  final int? fps;
  final Duration delay;
  final AnimationStatusListener? animationStatusListener;

  const AnimationOptions({
    required this.tween,
    this.control = AnimationControl.play,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.linear,
    this.startPosition = 0.0,
    this.fps,
    this.delay = Duration.zero,
    this.animationStatusListener,
  });
}

class UseAnimation<T> extends RtHook implements TickerProvider {
  @override
  @protected
  final $ = RtHook.$register;

  late final uTween = Rt.lazyState(
    () => UseState(options.tween),
    this,
  );
  late final uControl = Rt.lazyState(
    () => UseState(options.control),
    this,
  );
  late final uDuration = Rt.lazyState(
    () => UseState(options.duration),
    this,
  );
  late final uCurve = Rt.lazyState(
    () => UseState(options.curve),
    this,
  );

  bool _waitForDelay = true;
  Set<Ticker>? _tickers;
  late Animation<T> _animation;
  late final controller = _UseAnimationController(
    value: options.startPosition,
    duration: uDuration.value,
    vsync: this,
  );

  T get value => _animation.value;

  final AnimationOptions<T> options;

  UseAnimation(this.options) {
    controller.addStatusListener(_onAnimationStatus);
    _buildAnimation();

    UseEffect(_addFrameLimitingUpdater, []);
    UseEffect(_rebuild, [uTween, uControl, uCurve]);
    UseEffect(() => controller.duration = uDuration.value, [uDuration]);
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    final result = _AnimationTicker(
      onTick,
      this,
      debugLabel: 'created by $this',
    );

    _tickers ??= <_AnimationTicker>{};
    _tickers!.add(result);

    return result;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void play({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.play);
  }

  void playReverse({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.playReverse);
  }

  void playFromStart({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.playFromStart);
  }

  void playReverseFromEnd({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.playReverseFromEnd);
  }

  void loop({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.loop);
  }

  void mirror({Duration? duration}) {
    this.uDuration.value = duration ?? this.uDuration.value;
    uControl.update(() => uControl.value = AnimationControl.mirror);
  }

  void resume() {
    uControl.update(() => uControl.value = options.control);
  }

  void stop() {
    uControl.update(() => uControl.value = AnimationControl.stop);
  }

  void pause() {
    uControl.update(() => uControl.value = AnimationControl.pause);
  }

  void _addFrameLimitingUpdater() {
    final fps = options.fps;

    if (fps == null) {
      return controller.addListener(update);
    }

    var lastUpdateEmitted = DateTime(1970);
    final frameTimeMs = (1000 / fps).floor();

    controller.addListener(() {
      final now = DateTime.now();

      if (lastUpdateEmitted
          .isBefore(now.subtract(Duration(milliseconds: frameTimeMs)))) {
        lastUpdateEmitted = DateTime.now();
        update();
      }
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    options.animationStatusListener?.call(status);
    Rt.emit(this, status);
  }

  void _rebuild() {
    _buildAnimation();
    _asyncInitState();
  }

  void _buildAnimation() {
    _animation = uTween.value
        .chain(
          CurveTween(curve: uCurve.value),
        )
        .animate(controller);
  }

  void _asyncInitState() async {
    if (_waitForDelay && options.delay != Duration.zero) {
      await Future<void>.delayed(options.delay);
    }

    _waitForDelay = false;

    _applyControlInstruction();
  }

  void _applyControlInstruction() async {
    if (_waitForDelay) {
      return;
    }

    switch (uControl.value) {
      case AnimationControl.play:
        return unawaited(controller.play());
      case AnimationControl.playReverse:
        return unawaited(controller.playReverse());
      case AnimationControl.playFromStart:
        return unawaited(controller.forward(from: 0));
      case AnimationControl.playReverseFromEnd:
        return unawaited(controller.reverse(from: 1));
      case AnimationControl.loop:
        return unawaited(controller.loop());
      case AnimationControl.mirror:
        return unawaited(controller.mirror());
      case AnimationControl.pause:
        return controller.stop();
      case AnimationControl.stop:
        controller.stop();
        controller.reset();
        return;
    }
  }

  void _removeTicker(_AnimationTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }
}

/// Provides additional methods for playing, reversing, looping, and mirroring animations.
class _UseAnimationController extends AnimationController {
  bool _skipStopMirror = false;

  _UseAnimationController({
    required super.vsync,
    super.value,
    super.duration,
  });

  /// Starts playing the animation in forward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  TickerFuture play({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return forward();
  }

  /// Starts playing the animation in backward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  TickerFuture playReverse({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return reverse();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it starts over from the beginning.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  TickerFuture loop({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return repeat();
  }

  /// Starts playing the animation in an endless loop. After reaching the
  /// end, it plays it backwards, then forward and so on.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  /// The [duration] applies to the length of one loop iteration.
  ///
  /// Returns a [TickerFuture] that only completes when the animation gets
  /// canceled.
  TickerFuture mirror({Duration? duration}) {
    this.duration = duration ?? this.duration;

    removeStatusListener(_tickMirror);
    addStatusListener(_tickMirror);

    return _tickMirror(status);
  }

  @override
  void stop({bool canceled = true}) {
    if (!_skipStopMirror && canceled) removeStatusListener(_tickMirror);
    super.stop(canceled: canceled);
  }

  TickerFuture _tickMirror(AnimationStatus status) {
    _skipStopMirror = true;

    try {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.reverse) {
        return reverse();
      }

      return forward();
    } finally {
      _skipStopMirror = false;
    }
  }
}

// This class should really be called _DisposingTicker or some such, but this
// class name leaks into stack traces and error messages and that name would be
// confusing. Instead we use the less precise but more anodyne "_WidgetTicker",
// which attracts less attention.
class _AnimationTicker extends Ticker {
  _AnimationTicker(
    TickerCallback onTick,
    this._creator, {
    String? debugLabel,
  }) : super(
          onTick,
          debugLabel: debugLabel,
        );

  final UseAnimation _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
