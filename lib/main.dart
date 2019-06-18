import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mxanimal/Network/api.dart';
import 'package:mxanimal/page/DogPage.dart';
import 'package:mxanimal/page/CatPage.dart';
import 'package:mxanimal/page/AdPage.dart';

import 'package:firebase_admob/firebase_admob.dart';

import 'dart:math' show Random;

void main() {
  runApp(MyApp());
  // 初始化广告 API
  FirebaseAdMob.instance
      .initialize(appId: "");
  print("Main 执行结束");
}

// 测试网络接口方法
void testDogApi() {
  print("Start Request For All Breeds");
  Future result = DogApi.getRandomDog();
  result.then((onValue) {
    print(onValue);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MXAnimals',
      home: MyHomePage(title: 'Dog Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<DogPageWidget> dogKey = new GlobalKey<DogPageWidget>();

  GlobalKey<CatPageWidget> catKey = new GlobalKey<CatPageWidget>();

  List<BottomNavigationBarItem> items = new List<BottomNavigationBarItem>();

  List<Widget> pages = new List<Widget>();

  int currentIndex = 0;

  PageController _controller;

  BottomNavigationBar bottomBar;

  // 是否是广告
  bool isAd = false;

  @override
  void initState() {
    super.initState();
    var names = ["Dog", "Cat", "Random"];
    // 初始化猫狗页面, 以及控件
    for (int i = 0; i < 2; i++) {
      var item = new BottomNavigationBarItem(
          icon: new IconButton(
            icon: Image.asset(
              "assets/" + names[i].toLowerCase() + '.png',
              fit: BoxFit.fill,
            ),
            onPressed: null,
            iconSize: 32,
          ),
          activeIcon: new IconButton(
            icon: Image.asset(
              "assets/" + names[i].toLowerCase() + "_highlight.png",
              fit: BoxFit.fill,
            ),
            onPressed: null,
            iconSize: 32,
          ),
          title: new Text(names[i]));
      this.items.add(item);
      // 界面的初始化
      if (names[i] == "Dog") {
        // 狗
        this.pages.add(new DogPage(dogKey));
      } else {
        // 猫
        this.pages.add(new CatPage(catKey));
      }
    }
    // 初始化下方按钮
    this._controller = new PageController(
      initialPage: 0,
    );
    // 初始化广告页
    this.buildAdPage();
  }

  // 三秒后广告消失
  void dismissAd() async {
    Future.delayed(new Duration(seconds: 3)).then((value) {
      this.isAd = false;
      this.setState((){

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  // 加载广告页面或者是正常页面
  void buildAdPage() {
    // 33% percent for show the ad page
    if (Random(DateTime.now().second).nextInt(100) % 3 == 0) {
      AdPage adPage = AdPage();

      adPage.show();
    }

  }

  @override
  Widget build(BuildContext context) {
    // MainPage
    Widget mainPage = Scaffold(
      body: new PageView(
        children: this.pages,
        controller: this._controller,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: this.items,
        currentIndex: this.currentIndex,
        onTap: (int selected) {
          // 点击了
          if (currentIndex == selected) {
            // 滚动到顶部

          } else {
            // 切换
            this._controller.jumpToPage(selected);
            this.setState(() {
              this.currentIndex = selected;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
    return mainPage;
  }
}
