import 'package:flutter/material.dart';


class MXRouteManager {

  static MXRouteManager _manager;

  factory MXRouteManager() => _shareInstance();
  static MXRouteManager get instance => _shareInstance();
  static MXRouteManager _instance;

  MXRouteManager._internal() {
    // 初始化
  }

  static MXRouteManager _shareInstance() {
    if(_manager == null) {
      _manager = new MXRouteManager._internal();
    }
    return _manager;
  }

  void performAction(BuildContext context, String target, String action, Map params) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context){

    }));
  }
}
