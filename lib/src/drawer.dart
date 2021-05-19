import 'dart:math';

import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:slide_drawer/src/alignment.dart';
import 'package:slide_drawer/src/container.dart';
import 'package:slide_drawer/src/item.dart';

class SlideDrawer extends StatefulWidget {
  /// The gradient to use for the drawer background.
  ///
  /// If this is null, then [background] is used.
  final Gradient? backgroundGradient;

  /// The color to use for the drawer background. Typically this should be set
  /// along with [brightness].
  ///
  /// If this is null, then [ThemeData.primaryColor] is used.
  final Color? backgroundColor;

  /// The brightness of the drawer. Typically this is set along
  /// with [backgroundColor], [backgroundGradient].
  ///
  /// If this is null, then [ThemeData.primaryColorBrightness] is used.
  final Brightness? brightness;

  /// This is where you should attach your main application widget
  final Widget child;

  /// Custom drawer to be used when you don't want to use
  /// the default [SlideDrawerContainer] generated from [items] or [contentDrawer]
  final Widget? drawer;

  /// Head drawer to be rendered before [contentDrawer]
  /// or the default generated content drawer from [items]
  final Widget? headDrawer;

  /// Content drawer to be used if you don't want to use
  /// the default content drawer generated from [items]
  final Widget? contentDrawer;

  /// List of [MenuItem] to be used to generate the default content drawer
  final List<MenuItem> items;

  /// Duration of the drawer sliding animation
  ///
  /// Default is [Duration(milliseconds: 300)]
  final Duration duration;

  /// Curve to be used for the drawer sliding animation
  final Curve curve;

  /// Duration of the drawer sliding animation in the reverse direction
  final Duration? reverseDuration;

  /// Curve to be used for the drawer sliding animation in the reverse direction
  final Curve? reverseCurve;

  /// Vertical alignment of content inside drawer
  /// it can [start] from the top, or [center]
  final SlideDrawerAlignment? alignment;

  /// Offset from right to calculate the end point of sliding animation
  ///
  /// Default is 60.0
  final double offsetFromRight;

  /// Whether you want to rotate the [child] in the sliding animation
  ///
  /// Default is [true]
  final bool isRotate;

  /// Rotation angle of the [child] (radian) when
  /// the [SlideDrawer] sliding to the right
  ///
  /// Default is [pi / 2]
  final double rotateAngle;

  final Function? onWillPop;

  const SlideDrawer({
    Key? key,
    this.items = const [],
    this.drawer,
    this.headDrawer,
    this.contentDrawer,
    required this.child,
    this.backgroundGradient,
    this.backgroundColor,
    this.brightness,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.reverseDuration,
    this.reverseCurve,
    this.alignment,
    this.offsetFromRight = 60.0,
    this.rotateAngle = (pi / 24),
    this.isRotate = true,
    this.onWillPop,
  }) : super(key: key);

  static _SlideDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SlideDrawerState>();

  @override
  _SlideDrawerState createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer>
    with SingleTickerProviderStateMixin {
  bool _canBeDragged = false;
  double _minDragStartEdge = 60;
  double get _maxSlide =>
      MediaQuery.of(context).size.width - widget.offsetFromRight;
  double get _maxDragStartEdge => _maxSlide - 16;

  bool get _hasReverseCurve => widget.reverseCurve != null;
  bool get _hasReverseDuration => widget.reverseDuration != null;
  bool get _hasOnWillPop => widget.onWillPop != null;

  late CurvedAnimationController _animation;

  bool get isOpened => _animation.progress >= 1.0;
  bool get isClosed => _animation.value <= 0.0;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  _initAnimation() {
    _animation = CurvedAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
      reverseCurve: _hasReverseCurve ? widget.reverseCurve : widget.curve,
      reverseDuration:
          _hasReverseDuration ? widget.reverseDuration : widget.duration,
      debugLabel: 'SlideDrawer',
    );

    _animation.addListener(() => setState(() {}));
  }

  reset() {
    _animation.dispose();
    _initAnimation();
  }

  open() => _animation.start();
  close() => _animation.reverse();
  toggle() => isOpened ? close() : open();

  _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animation.isDismissed && details.globalPosition.dx < _minDragStartEdge;

    bool isDragCloseFromRight =
        _animation.isCompleted && details.globalPosition.dx > _maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged && details.primaryDelta != null) {
      double delta = details.primaryDelta! / _maxSlide;
      _animation.progress += delta;
    }
  }

  _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (_animation.isDismissed || _animation.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animation.fling(velocity: visualVelocity);
    } else if (_animation.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  Widget get _drawer => SlideDrawerContainer(
        alignment: widget.alignment,
        brightness: widget.brightness,
        backgroundColor: widget.backgroundColor,
        backgroundGradient: widget.backgroundGradient,
        head: widget.headDrawer,
        content: widget.contentDrawer,
        drawer: widget.drawer,
        items: widget.items,
        paddingRight: widget.offsetFromRight,
      );

  Matrix4 get _transform => Matrix4.identity()
    ..translate(_maxSlide * _animation.value)
    ..scale(1.0 - (0.25 * _animation.value))
    ..setEntry(3, 2, 0.001)
    ..rotateY(_animation.value * widget.rotateAngle);

  Matrix4 get _transformNoRotate => Matrix4.identity()
    ..translate(_maxSlide * _animation.value)
    ..scale(1.0 - (0.25 * _animation.value));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOpened) {
          close();
          return Future.value(false);
        } else if (_hasOnWillPop) {
          return widget.onWillPop?.call();
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            _drawer,
            Transform(
              alignment: Alignment.centerLeft,
              transform: widget.isRotate ? _transform : _transformNoRotate,
              child: Material(
                child: Stack(
                  children: [
                    widget.child,
                    if (isOpened)
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white.withOpacity(0.01),
                        ),
                        onTap: close,
                      ),
                  ],
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
