import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

enum MXUserHintType {
  MXUserHintTypeArrowVertical,
  MXUserHintTypeArrowHorizontal
}

class HideUserHintNotification extends Notification {
  final String msg;

  HideUserHintNotification(this.msg);
}

class MXUserHint extends StatelessWidget {
  final String hint;

  final MXUserHintType type;

  MXUserHint(this.hint, this.type);

  Widget buildDirection(BuildContext context) {
    Widget result;
    if (this.type == MXUserHintType.MXUserHintTypeArrowHorizontal) {
      // 水平方向
      result = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 左边的箭头
          new Container(
            height: 64,
            width: 64,
            child: Image.asset(
              "assets/arrow-left.png",
              fit: BoxFit.fill,
            ),
          ),
          // 中间的文案
          new Expanded(
              child: new Text(
            this.hint,
            style: new TextStyle(color: Colors.white, fontSize: 16),
          )),
          // 右边的箭头
          new Container(
            height: 64,
            width: 64,
            child: Image.asset(
              "assets/arrow-right.png",
              fit: BoxFit.fill,
            ),
          ),
        ],
      );
    } else {
      // 垂直方向
      result = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 上方的箭头
          new Container(
            height: 64,
            width: 64,
            child: Image.asset(
              "assets/arrow-up.png",
              fit: BoxFit.fill,
            ),
          ),
          // 中间的文案
          new Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                (MediaQuery.of(context).size.width / 2.0 - 60) / 2.0,
                20,
                (MediaQuery.of(context).size.width / 2.0 - 60) / 2.0),
            child: new Text(this.hint,
                style: new TextStyle(color: Colors.white, fontSize: 16)),
          ),
          // 下方的箭头
          new Container(
            height: 64,
            width: 64,
            child: Image.asset(
              "assets/arrow-down.png",
              fit: BoxFit.fill,
            ),
          )
        ],
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails detail) {
        // 发送通知
        print("Hide: post notification");
        HideUserHintNotification("hide").dispatch(context);
      },
      child: new Container(
          height: window.physicalSize.height,
          width: window.physicalSize.width,
          color: Color.fromRGBO(0, 0, 0, 0.6),
          child: this.buildDirection(context) //,
          ),
    );
  }
}
