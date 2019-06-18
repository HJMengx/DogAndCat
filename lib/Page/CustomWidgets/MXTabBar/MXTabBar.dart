import 'package:flutter/material.dart';
import 'dart:ui' as ui;

typedef SelectedIndexChange = void Function(int index);

enum MXBottomType { MXBottomImport, MXBottomNormal }


class MXTabBar extends StatefulWidget with PreferredSizeWidget {

  double width;

  double height;

  final List<Widget> tabs;

  MXTabBar(this.tabs) : assert(tabs != null);

  @override
  State<StatefulWidget> createState() {
    return new _MXTabBarState();
  }

  @override
  Size get preferredSize => Size(
      width = width ?? MediaQueryData.fromWindow(ui.window).size.width,
      height ?? 46);
}


class _MXTabBarState extends State<MXTabBar> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}