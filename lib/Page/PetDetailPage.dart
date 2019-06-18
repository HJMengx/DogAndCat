import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:mxanimal/models/cat.dart';
import 'package:mxanimal/page/CustomWidgets/PetAttributeWidget.dart';
import 'package:mxanimal/page/CustomWidgets/MXUserHint.dart';

import 'dart:async';

class AnimalImagesPage extends StatefulWidget {
  final List<String> listImages;

  final String breed;

  final String imgType;

  final dynamic petInfo;

  AnimalImagesPage(
      {Key key, this.listImages, this.breed, this.imgType, this.petInfo})
      : assert(breed != null),
        assert(imgType != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new AnimalImagesPageState();
  }
}

const int paddingValue = 20;

class AnimalImagesPageState extends State<AnimalImagesPage>
    with TickerProviderStateMixin {
  AnimationController _nextAnimationController;

  AnimationController _saveAnimationController;

  // 下一张动画, 分别有翻转以及透明度变换为主
  Animation<double> opacityAnimation;

  Animation<Matrix4> transformAnimation;

  // 保存到手机动画, 目前可以先做个动画
  Animation<Matrix4> saveToPhotos;

  // 上一张
  Tween formerAnimation;

  // 滑动的上一个位置, 达到一定的触发条件才执行
  double dragPositionFormer = 0.0;

  double offsetDy = 0.0;

  final double threshold = 100.0;

  int index = 0;

  // 是否为第一次登录
  bool isLook = false;

  // 是否是正在保存
  bool isSaving = false;

  // 文案
  String savingResult = "保存成功";

  // 拖动中途的变换
  Matrix4 dragUpdateTransform = Matrix4.identity();

  // WebView 的控制
  Completer<WebViewController> _controller = Completer<WebViewController>();

  // 初始化动画
  void _initAnimation() {
    // 透明度动画
    this.opacityAnimation = new Tween(begin: 1.0, end: 0.0).animate(
        new CurvedAnimation(
            parent: this._nextAnimationController, curve: Curves.decelerate))
      ..addListener(() {
        this.setState(() {
          // 通知 Fluter Engine 重绘
        });
      });
    // 翻转动画
    var startTrans = Matrix4.identity()..setEntry(3, 2, 0.006);
    var endTrans = Matrix4.identity()
      ..setEntry(3, 2, 0.006)
      ..rotateX(3.1415927);
    this.transformAnimation = new Tween(begin: startTrans, end: endTrans)
        .animate(new CurvedAnimation(
            parent: this._nextAnimationController, curve: Curves.easeIn))
          ..addListener(() {
            this.setState(() {});
          });
    // 缩放
    var saveStartTrans = Matrix4.identity()..setEntry(3, 2, 0.006);
    // 平移且缩放
    var saveEndTrans = Matrix4.identity()
      ..setEntry(3, 2, 0.006)
      ..scale(0.1, 0.1)
      ..translate(-20.0, 20.0); // MediaQuery.of(context).size.height
    this.saveToPhotos = new Tween(begin: saveStartTrans, end: saveEndTrans)
        .animate(new CurvedAnimation(
            parent: this._saveAnimationController, curve: Curves.easeIn))
          ..addListener(() {
            this.setState(() {});
          });
  }

  void _initController() {
    // 初始化控制器
    this._saveAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 800));
    this._nextAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 800));
  }

  @override
  void initState() {
    super.initState();
    this._initController();
    // 获取是否是第一次登录的数据
    this.getIsFirst();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 动画的初始化
    this._initAnimation();
  }

  @override
  void dispose() {
    // 如果还在执行动画, 强制结束
    if (this._nextAnimationController.isAnimating) {
      this._nextAnimationController.stop();
    }
    if (this._saveAnimationController.isAnimating) {
      this._saveAnimationController.stop();
    }
    // 动画停止后, 释放资源
    this._nextAnimationController.dispose();
    this._saveAnimationController.dispose();
    // 设置已经观看过的标识值
    if (!this.isLook) {
      this.looked();
    }
    // 最后释放自己
    super.dispose();
  }

  void dismissLoading() async {
    Future.delayed(new Duration(seconds: 2)).then((value) {
      this.setState(() {
        this.isSaving = false;
      });
    });
  }

  void save() async {
    // TODO: 开始保存文件
    FileInfo imgFile = await DefaultCacheManager()
        .store
        .getFile(this.widget.listImages[this.index]);
    String filePath = null;
    if (imgFile != null) {
      // 直接保存
      filePath = await ImagePickerSaver.saveFile(
          fileData: imgFile.file.readAsBytesSync());
    } else {
      // 下载后在保存
      var response = await http.get(this.widget.listImages[this.index]);

      debugPrint(response.statusCode.toString());

      filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
    }
    if (filePath != null) {
      // 保存框消失
      this.savingResult = "保存成功";
    } else {
      // 保存框消失
      this.savingResult = "保存失败";
    }
    this.isSaving = true;
    this.setState(() {});
    this.dismissLoading();
    print(filePath);
  }

  // 记录开始拖动的位置
  void nextStart(DragStartDetails start) {
    this.dragPositionFormer = start.globalPosition.dy;
  }

  // 拖动的过程, 需要改变Transform的值
  void nextUpdate(DragUpdateDetails update) {
    // 计算偏移量
    this.offsetDy = update.globalPosition.dy - this.dragPositionFormer;
    // 图片进行形变
    double angle = 0;

    if (this.offsetDy > 150) {
      angle = 3.1415926 / 6.0 * (this.offsetDy > 0 ? 1 : -1);
    } else if (this.offsetDy < 0 && this.offsetDy.abs() > 150) {
      angle = 3.1415926 / -12.0;
    } else {
      angle = offsetDy / 180.0 / 6.0;
    }
    print("angle is $angle");
    this.dragUpdateTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.006)
      ..rotateX(angle);
    // 渲染效果
    this.setState(() {});
  }

  // 结束的位置, 进行判断
  void next(DragEndDetails detail) async {
    this.dragUpdateTransform = Matrix4.identity();
    // 达到一定的阈值才执行动画
    if (this.offsetDy >= this.threshold) {
      // 开始执行动画
      try {
        if (this.index >= this.widget.listImages.length - 1) {
          this.index = this.widget.listImages.length - 1;
          // 保证缩放回去
          this.setState(() {});
        } else {
          await _nextAnimationController.forward().whenComplete(() {
            //先正向执行动画
            this.index++;
            this.setState(() {
              print("here");
            });
          }).then((value) {
            this._nextAnimationController.reset();
          });
        }
      } on TickerCanceled {}
    } else if (this.offsetDy.abs() >= this.threshold) {
      this.index--;
      if (this.index >= 0) {
        await this._nextAnimationController.reverse().then((value) {
          this.setState(() {
            print("上一张");
          });
        });
      } else {
        this.index = 0;
        this.setState(() {
          print("hasn`t enough images.");
        });
      }
    } else {
      // 还原形变
      this.setState(() {});
    }
  }

  // 控件, 图片控件
  Widget buildPetItem(bool isSelected, int item) {
    // 初始化控件
    Matrix4 transform;
    double opacity;
    if (isSelected) {
      transform = this.transformAnimation.value;
      opacity = this.opacityAnimation.value;
    } else {
      transform = Matrix4.identity();
      opacity = 1.0;
    }

    Widget pet = new GestureDetector(
      onVerticalDragUpdate: nextUpdate,
      onVerticalDragStart: nextStart,
      onVerticalDragEnd: next,
      child: new Transform(
        transform: this.dragUpdateTransform,
        child: Container(
          child: new Transform(
            alignment: Alignment.bottomLeft,
            transform: transform,
            child: new Opacity(
              opacity: opacity,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width / 1.5 - 30,
//            color: Color.fromRGBO(0, 0, 0, 1.0 - 0.1 * item),
                child: new Padding(
                  padding: EdgeInsets.all(0),
                  child: new CachedNetworkImage(
                    imageUrl: this.widget.listImages[item],
                    fit: BoxFit.fill,
                    placeholder: (context, content) {
                      return new Container(
                        width: MediaQuery.of(context).size.width / 2.0 - 40,
                        height: MediaQuery.of(context).size.width / 2.0 - 60,
                        color: Color(0xFF2FC77D),
                        child: new Center(
                          child: new CupertinoActivityIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return pet;
  }

  // 控件: 宠物的详细信息
  Widget buildPetDetailInfo() {
    if (this.widget.imgType == "Dog") {
      // TODO: 狗狗类型没有详细数据, 需要自己向 Wiki 获取并解析, 待完成
      Widget webView = new Padding(
        padding: EdgeInsets.fromLTRB(6, 10, 6, 0),
        child: new SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.width / 1.2 -
              74.0,
          child: new WebView(
            initialUrl: "https://en.wikipedia.org/wiki/${this.widget.breed}",
            onPageFinished: (content) {
              print("loading complete $content");
            },
            onWebViewCreated: (controller) {
              if (!this._controller.isCompleted) {
                this._controller.complete(controller);
              }
            },
          ),
        ),
      );
      return webView;
    } else if (this.widget.imgType == "Cat") {
      // 获取详情
      CatBreed catInfo = this.widget.petInfo as CatBreed;
      // 描述
      Widget descriptionLabel = new Padding(
        padding: EdgeInsets.fromLTRB(6.0, 20.0, 6.0, 0),
        child: new Text(
          catInfo.description,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      );

      Widget listView = new ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return descriptionLabel;
                break;
              case 1:
                return
                  new Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: new Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  );
                break;
              case 2:
                // 喜爱程度-Affection Level
                return new PetAttributeWidget(
                  attributeName: "Affection Level",
                  degree: catInfo.affection_level ?? 0,
                );
                break;
              case 3:
                // 适养性-Adaptability
                return new PetAttributeWidget(
                  attributeName: "Adaptability",
                  degree: catInfo.adaptability ?? 0,
                );
                break;
              case 4:
                // 儿童友好度-Child Friendly
                return new PetAttributeWidget(
                  attributeName: "Child Friendly",
                  degree: catInfo.child_friendly ?? 0,
                );
                break;
              case 5:
                // 犬类友好度-Dog Friendly
                return new PetAttributeWidget(
                  attributeName: "Dog Friendly",
                  degree: catInfo.dog_friendly ?? 0,
                );
                break;
              case 6:
                // 精力-Energy Level
                return new PetAttributeWidget(
                  attributeName: "Energy Level",
                  degree: catInfo.energy_level ?? 0,
                );
                break;
              case 7:
                // 打扮-Grooming
                return new PetAttributeWidget(
                  attributeName: "Grooming",
                  degree: catInfo.grooming ?? 0,
                );
                break;
              case 8:
                // 健康问题-Health Issues
                return new PetAttributeWidget(
                  attributeName: "Health Issues",
                  degree: catInfo.health_issues ?? 0,
                );
                break;
              case 9:
                // 智力-Intelligence
                return new PetAttributeWidget(
                  attributeName: "Intelligence",
                  degree: catInfo.intelligence ?? 0,
                );
                break;
              case 10:
                // 脱毛程度-Shedding Level
                return new PetAttributeWidget(
                  attributeName: "Shedding Level",
                  degree: catInfo.shedding_level ?? 0,
                );
                break;
              case 11:
                // 社交需要-Social Needs
                return new PetAttributeWidget(
                  attributeName: "Social Needs",
                  degree: catInfo.social_needs ?? 0,
                );
                break;
              case 12:
                // 陌生人友好度-Stranger Friendly
                return new PetAttributeWidget(
                  attributeName: "Stranger Friendly",
                  degree: catInfo.stranger_friendly ?? 0,
                );
                break;
              case 12:
                // 声音-Vocalisation
                return new PetAttributeWidget(
                  attributeName: "Vocalisation",
                  degree: catInfo.vocalisation ?? 0,
                );
                break;
              default:
                break;
            }
          });

      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
//          descriptionLabel,
//          new Padding(
//            padding: EdgeInsets.only(top: 10),
//            child: new Container(
//              height: 1,
//              width: MediaQuery.of(context).size.width,
//              color: Colors.white,
//            ),
//          ),
          new Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width / 1.2 - 80,
            width: MediaQuery.of(context).size.width,
            child: listView,
          ),
        ],
      );
    }
  }

  void getIsFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("looked")) {
      this.setState(() {
        this.isLook = prefs.getBool("looked");
      });
    } else {
      prefs.setBool("looked", false);
      this.setState(() {
        this.isLook = false;
      });
    }
    print("isLook:${this.isLook}");
  }

  void looked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("looked", true);
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否是第一次启动, 是的话就展示提示
    List<Widget> items = new List<Widget>();

    for (int item = 0; item < this.widget.listImages.length; item++) {
      bool selected = false;
      if (item == this.index) {
        selected = true;
      }
      items.add(this.buildPetItem(selected, item));
    }
    // 内容 Widget
    Widget contentWidget = new Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: this.widget.imgType == "Dog" ? Colors.white : Colors.black,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Column(
          children: <Widget>[
            new IndexedStack(
              index: this.index,
              children: items,
            ),
            this.buildPetDetailInfo()
          ],
        ),
      ),
    );
    // 提示 Widget
    Widget hintWidget = new NotificationListener<HideUserHintNotification>(
        onNotification: (HideUserHintNotification notification) {
          // Receive Noti, need to hide
          print("recv the noti");
          this.looked();
          this.isLook = true;
          this.setState(() {});
        },
        child: new MXUserHint(
            "您可以通过在图片上上下滑动来切换宠物图片(You can switch pets by sliding up or down on the image)",
            MXUserHintType.MXUserHintTypeArrowVertical));
    // 加载控件
    Widget loading = new Center(
      child: new Container(
        decoration: new BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.8), width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        width: 100,
        height: 40,
//        color: Color.fromRGBO(0, 0, 0, 0.6),
        margin: EdgeInsets.only(top: 40),
        child: new Text(
          this.savingResult,
          style: new TextStyle(color: Colors.white),
        ),
      ),
    );
    Widget scaffold = new Scaffold(
      appBar: new AppBar(
        title: new Text(this.widget.breed),
        backgroundColor: Color(0xFF2FC77D),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.file_download),
              onPressed: () {
                this.save();
              })
        ],
      ),
      backgroundColor:
          this.widget.imgType == "Dog" ? Colors.white : Colors.black,
      body: new Stack(
        children: <Widget>[
          contentWidget,
          this.isLook ? new Container() : hintWidget,
          this.isSaving ? loading : new Container()
        ],
      ),
    );
    return scaffold;
  }
}

// 分别控制不成功
/*
*     Widget test = new Scaffold(
        appBar: new AppBar(
          title: new Text(this.widget.breed),
          backgroundColor: Color(0xFF2FC77D),
        ),
        backgroundColor: Colors.black,
        body: new Center(
          child: new Stack(
            children: List.generate(10, (index){
              int top = (10 - index) * 20;
              Matrix4 transform;
              double opacity;
              if (this.index == index) {
                transform = this.transformAnimation.value;
                opacity = this.opacityAnimation.value;
              } else {
                transform = Matrix4.identity();
                opacity = 1.0;
              }

              return new Positioned(
                top: top.toDouble(),
                left: (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 1.2) / 2,
                child: new GestureDetector(
                  onTap: save,
                  onVerticalDragUpdate: nextUpdate,
                  onVerticalDragStart: nextStart,
                  onVerticalDragEnd: next,
                  child: new Transform(
                    transform: this.dragUpdateTransform,
                    child: Container(
                      child: new Transform(
                        alignment: Alignment.bottomLeft,
                        transform: transform,
                        child: new Opacity(
                          opacity: opacity,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 1.5 - 30,
//            color: Color.fromRGBO(0, 0, 0, 1.0 - 0.1 * item),
                            child: new Padding(
                              padding: EdgeInsets.all(0),
                              child: new CachedNetworkImage(
                                imageUrl: this.widget.listImages[index],
                                fit: BoxFit.fill,
                                placeholder: (context, content) {
                                  return new Container(
                                    width: MediaQuery.of(context).size.width / 2.0 - 40,
                                    height: MediaQuery.of(context).size.width / 2.0 - 60,
                                    color: Color(0xFF2FC77D),
                                    child: new Center(
                                      child: new CupertinoActivityIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
    );
  */
