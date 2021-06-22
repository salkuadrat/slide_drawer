import 'package:flutter/material.dart';

class MenuItem {
  /// Widget to be used for the leading of [MenuTtemWidget]
  ///
  /// If this is null, then it will use Icon with IconData from [icon]
  final Widget? leading;

  /// Icon to be used in the leading widget of [MenuItemWidget]
  final IconData? icon;

  /// Text to be used for the title of [MenuItemWidget]
  final String title;

  final bool isCloseDrawerWhenTapped;

  /// Function to be called when this [MenuItemWidget] is tapped
  final void Function()? onTap;

  bool get hasIcon => icon != null;
  bool get hasLeading => leading != null;

  MenuItem(
    this.title, {
    this.icon,
    this.leading,
    this.onTap,
    this.isCloseDrawerWhenTapped = true,
  });
}
