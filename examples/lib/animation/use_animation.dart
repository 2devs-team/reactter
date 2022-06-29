import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:reactter/reactter.dart';

/// Set of instruction you can pass into a [CustomAnimation.control].
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
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  loop,

  /// Endlessly plays the animation from the start to the end, then
  /// it plays reverse to the start, then forward again and so on.
  /// Make sure to utilize [CustomAnimation.child] since a permanent
  /// animation eats up performance.
  mirror,

  /// Stops the animation at the current position.
  stop,
}

enum _AnimationStatus { start, completed }

/// Method extensions on [AnimationController]
extension _AnimationControllerExtension on AnimationController {
  /// Starts playing the animation in forward direction.
  ///
  /// If a [duration] named parameter is provided it will be
  /// applied as the [AnimationController.duration] value.
  ///
  /// Returns a [TickerFuture] that completes when the animation ends or
  /// get canceled.
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.play(5.seconds);
  /// ```
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
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.playReverse(5.seconds);
  /// ```
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
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.loop(5.seconds);
  /// ```
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
  ///
  /// Example: (using [supercharged](https://pub.dev/packages/supercharged))
  /// ```dart
  /// controller.mirror(5.seconds);
  /// ```
  TickerFuture mirror({Duration? duration}) {
    this.duration = duration ?? this.duration;
    return repeat(reverse: true);
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
  final AnimationOptions<T> options;
  final ReactterContext? context;

  late final tween = UseState(options.tween, this);
  late final control = UseState(options.control, this);
  late final duration = UseState(options.duration, this);
  late final curve = UseState(options.curve, this);

  final _subscribersManager = ReactterSubscribersManager<_AnimationStatus>();

  late Animation<T> _animation;
  T get value => _animation.value;

  late final _aniController = AnimationController(
    value: options.startPosition,
    duration: duration.value,
    vsync: this,
  );

  var _waitForDelay = true;
  var _isPlaying = false;
  var _isControlSetToMirror = false;
  Set<Ticker>? _tickers;

  UseAnimation(this.options, [this.context]) : super(context) {
    context?.onDidMount((_, __) => _addFrameLimitingUpdater());

    context?.onWillUnmount((_, __) => _aniController.dispose());

    _aniController.addStatusListener(_onAnimationStatus);

    _buildAnimation();

    UseEffect(_rebuild, [tween, control, curve], context);

    UseEffect(() {
      _aniController.duration = duration.value;
    }, [duration], context);
  }

  void play({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.play;
    });
  }

  void playReverse({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.playReverse;
    });
  }

  void playFromStart({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.playFromStart;
    });
  }

  void playReverseFromEnd({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.playReverseFromEnd;
    });
  }

  void loop({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.loop;
    });
  }

  void mirror({Duration? duration}) {
    this.duration.value = duration ?? this.duration.value;

    control.update(() {
      control.value = AnimationControl.mirror;
    });
  }

  void stop() {
    control.update(() {
      control.value = AnimationControl.stop;
    });
  }

  Function onStart(Function callback) {
    _subscribersManager.subscribe(_AnimationStatus.start, callback);

    return () =>
        _subscribersManager.unsubscribe(_AnimationStatus.start, callback);
  }

  Function onComplete(Function callback) {
    _subscribersManager.subscribe(_AnimationStatus.completed, callback);

    return () =>
        _subscribersManager.unsubscribe(_AnimationStatus.completed, callback);
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    final result =
        _AnimationTicker(onTick, this, debugLabel: 'created by $this');

    _tickers ??= <_AnimationTicker>{};
    _tickers!.add(result);

    return result;
  }

  void _addFrameLimitingUpdater() {
    final fps = options.fps;

    if (fps == null) {
      return _aniController.addListener(update);
    }

    var lastUpdateEmitted = DateTime(1970);
    final frameTimeMs = (1000 / fps).floor();

    _aniController.addListener(() {
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

    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      _trackPlaybackStart();
    } else if (status == AnimationStatus.dismissed ||
        status == AnimationStatus.completed) {
      _trackPlaybackComplete();
    }
  }

  void _rebuild() {
    _buildAnimation();
    _asyncInitState();
  }

  void _buildAnimation() {
    _animation = tween.value
        .chain(
          CurveTween(curve: curve.value),
        )
        .animate(_aniController);
  }

  void _trackPlaybackStart() {
    if (!_isPlaying) {
      _isPlaying = true;
      _subscribersManager.publish(_AnimationStatus.start);
    }
  }

  void _trackPlaybackComplete() {
    if (_isPlaying) {
      _isPlaying = false;
      _subscribersManager.publish(_AnimationStatus.completed);
    }
  }

  void _asyncInitState() async {
    if (_waitForDelay == true && options.delay != Duration.zero) {
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
      return unawaited(_aniController.play());
    }

    if (control.value == AnimationControl.playReverse) {
      return unawaited(_aniController.playReverse());
    }

    if (control.value == AnimationControl.playFromStart) {
      return unawaited(_aniController.forward(from: 0.0));
    }

    if (control.value == AnimationControl.playReverseFromEnd) {
      return unawaited(_aniController.reverse(from: 1.0));
    }

    if (control.value == AnimationControl.loop) {
      return unawaited(_aniController.loop());
    }

    if (control.value == AnimationControl.mirror) {
      if (_isControlSetToMirror) {
        _isControlSetToMirror = false;
        return;
      }

      _isControlSetToMirror = true;
      return unawaited(_aniController.mirror());
    }

    _trackPlaybackComplete();
    _aniController.stop();
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
