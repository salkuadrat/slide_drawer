import 'package:flutter/material.dart';
import 'package:slide_drawer/src/alignment.dart';
import 'package:slide_drawer/src/item.dart';

import 'drawer.dart';

class SlideDrawerContainer extends StatelessWidget {
  final Widget? drawer;
  final Widget? head;
  final Widget? content;
  final List<SlideDrawerMenuItem> items;
  final double paddingRight;

  /// The gradient to use for the background.
  ///
  /// If this property is null, then [background] is used.
  final Gradient? backgroundGradient;

  /// The color to use for the background. Typically this should be set
  /// along with [brightness].
  ///
  /// If this property is null, then [ThemeData.primaryColor] is used.
  final Color? backgroundColor;

  /// The brightness of the app bar's material. Typically this is set along
  /// with [backgroundColor], [backgroundGradient].
  ///
  /// If this property is null, then [ThemeData.primaryColorBrightness] is used.
  final Brightness? brightness;

  /// Vertical alignment of content inside [SlideDrawerContainer]
  /// it can [start] from the top, or [center]
  final SlideDrawerAlignment? alignment;

  bool get _hasItems => items.isNotEmpty;
  bool get _hasDrawer => drawer != null;
  bool get _hasHead => head != null;
  bool get _hasContent => content != null;
  bool get _hasGradient => backgroundGradient != null;

  SlideDrawerContainer({
    Key? key,
    required this.drawer,
    this.head,
    this.content,
    this.items = const [],
    this.brightness,
    this.backgroundColor,
    this.backgroundGradient,
    this.alignment,
    this.paddingRight = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SlideDrawerAlignment? _alignment = alignment;

    if (_alignment == null) {
      _alignment =
          _hasHead ? SlideDrawerAlignment.start : SlideDrawerAlignment.center;
    }

    bool _isAlignTop = _alignment == SlideDrawerAlignment.start;

    return Material(
      child: _hasDrawer
          ? drawer
          : Container(
              decoration: _hasGradient
                  ? BoxDecoration(gradient: backgroundGradient)
                  : BoxDecoration(color: backgroundColor ?? theme.primaryColor),
              child: SafeArea(
                child: Theme(
                  data: ThemeData(brightness: brightness ?? theme.brightness),
                  child: Column(
                    mainAxisAlignment: _isAlignTop
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_hasHead) head!,
                      if (_hasContent)
                        Container(
                          margin: EdgeInsets.only(right: paddingRight),
                          child: content,
                        ),
                      if (!_hasContent && _hasItems)
                        for (SlideDrawerMenuItem item in items)
                          Container(
                            margin: EdgeInsets.only(right: paddingRight),
                            child: SlideDrawerMenuItemWidget(item: item),
                          ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class SlideDrawerMenuItemWidget extends StatelessWidget {
  final SlideDrawerMenuItem item;

  SlideDrawerMenuItemWidget({Key? key, required this.item}) : super(key: key);

  Widget? get _leading {
    if (item.hasLeading) return item.leading!;
    if (item.hasIcon) return Icon(item.icon);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _leading,
      contentPadding: EdgeInsets.only(left: _leading == null ? 24 : 16),
      title: Text(item.title),
      onTap: () {
        if (item.isCloseDrawerWhenTapped) {
          SlideDrawer.of(context)?.close();
        }

        item.onTap?.call();
      },
    );
  }
}
