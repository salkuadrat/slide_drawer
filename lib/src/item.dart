import 'package:flutter/material.dart';

class SlideMenuItem {
  /// Widget to be used for the leading of [MenuTtemWidget]
  ///
  /// If this is null, then it will use Icon with IconData from [icon]
  final Widget? leading;

  /// Icon to be used in the leading widget of [SlideMenuItemWidget]
  final IconData? icon;

  /// Text to be used for the title of [SlideMenuItemWidget]
  final String title;

  final bool isCloseDrawerWhenTapped;

  /// Function to be called when this [SlideMenuItemWidget] is tapped
  final void Function()? onTap;

  bool get hasIcon => icon != null;
  bool get hasLeading => leading != null;

  SlideMenuItem(
    this.title, {
    this.icon,
    this.leading,
    this.onTap,
    this.isCloseDrawerWhenTapped = true,
  });
}
