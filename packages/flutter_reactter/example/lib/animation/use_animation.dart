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
  stop,
}

/// Method extensions on [AnimationController]
extension _AnimationControllerExtension on AnimationController {
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

    stopMirror();
    addStatusListener(_tickMirror);

    return _tickMirror(status);
  }

  void stopMirror() => removeStatusListener(_tickMirror);

  TickerFuture _tickMirror(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.reverse) {
      return reverse();
    }

    return forward();
  }
}

class AnimationOptions<T> {
  final Animatable<T> tween;
  final Duration duration;
  final AnimationControl control;
  final Curve curve;
  final double startPosition;
  final int? fps;
  final Duration delay;
  final AnimationStatusListener? animationStatusListener;

  AnimationOptions({
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

class UseAnimation<T> extends ReactterHook implements TickerProvider {
  @override
  final $ = ReactterHook.$register;

  late final tween = Reactter.lazy(() => UseState(options.tween), this);
  late final control = Reactter.lazy(() => UseState(options.control), this);
  late final duration = Reactter.lazy(() => UseState(options.duration), this);
  late final curve = Reactter.lazy(() => UseState(options.curve), this);

  bool _waitForDelay = true;
  Set<Ticker>? _tickers;
  late Animation<T> _animation;
  late final _animationController = AnimationController(
    value: options.startPosition,
    duration: duration.value,
    vsync: this,
  );

  T get value => _animation.value;
  AnimationController get animationController => _animationController;

  final AnimationOptions<T> options;

  UseAnimation(this.options) {
    _animationController.addStatusListener(_onAnimationStatus);
    _buildAnimation();

    UseEffect(
      _addFrameLimitingUpdater,
      [],
      this,
    );

    UseEffect(
      _rebuild,
      [tween, control, curve],
      this,
    );

    UseEffect(
      () => _animationController.duration = duration.value,
      [duration],
      this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void play({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.play);
  }

  void playReverse({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.playReverse);
  }

  void playFromStart({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.playFromStart);
  }

  void playReverseFromEnd({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.playReverseFromEnd);
  }

  void loop({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.loop);
  }

  void mirror({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;
    control.update(() => control.value = AnimationControl.mirror);
  }

  void stop() {
    control.update(() => control.value = AnimationControl.stop);
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

  void _addFrameLimitingUpdater() {
    final fps = options.fps;

    if (fps == null) {
      return _animationController.addListener(update);
    }

    var lastUpdateEmitted = DateTime(1970);
    final frameTimeMs = (1000 / fps).floor();

    _animationController.addListener(() {
      final now = DateTime.now();

      if (lastUpdateEmitted
          .isBefore(now.subtract(Duration(milliseconds: frameTimeMs)))) {
        lastUpdateEmitted = DateTime.now();
        update();
      }
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    // final isMirror = control.value == AnimationControl.mirror;

    // if (isMirror) {
    //   unawaited(_aniController.mirror());
    // }

    options.animationStatusListener?.call(status);
    Reactter.emit(this, status);
  }

  void _rebuild() {
    _buildAnimation();
    _asyncInitState();
  }

  void _buildAnimation() {
    _animation = tween.value
        .chain(CurveTween(curve: curve.value))
        .animate(_animationController);
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

    if (control.value == AnimationControl.play) {
      return unawaited(_animationController.play());
    }

    if (control.value == AnimationControl.playReverse) {
      return unawaited(_animationController.playReverse());
    }

    if (control.value == AnimationControl.playFromStart) {
      return unawaited(_animationController.forward(from: 0.0));
    }

    if (control.value == AnimationControl.playReverseFromEnd) {
      return unawaited(_animationController.reverse(from: 1.0));
    }

    if (control.value == AnimationControl.loop) {
      return unawaited(_animationController.loop());
    }

    if (control.value == AnimationControl.mirror) {
      return unawaited(_animationController.mirror());
    }

    _animationController.stop();

    _animationController.stopMirror();
  }

  void _removeTicker(_AnimationTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
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
