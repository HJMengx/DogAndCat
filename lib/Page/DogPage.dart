// Flutter SDK And Dart SDK
import 'package:flutter/material.dart';
import 'package:mxanimal/page/CustomWidgets/ProgressDialog.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';

// 第三方工具
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 内部工具
import 'package:mxanimal/Network/api.dart';
import 'package:mxanimal/models/dog.dart';
import 'package:mxanimal/page/CustomWidgets/SelectedWidget.dart';
import 'package:mxanimal/page/CustomWidgets/MXPicker.dart';
import 'package:mxanimal/page/RouteManager/MXRouteManager.dart';

// 后续优化代码完成 RouteManager 之后再去除掉路由, 先完成动画
import 'package:mxanimal/page/PetDetailPage.dart';

class DogPage extends StatefulWidget {
  // 通过全局Key 来控制 Widget
  DogPage(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DogPageWidget();
  }
}

// 导航栏部分
class DogPageWidget extends State<DogPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isLoading = true;

  AllBreeds breeds;

  DogImageForIndicateBreed breedImgs;

  int selectedIdx = 0;

  int formerSelected = 0;

  GlobalKey categoryKey = new GlobalKey();

  Offset pickerPosition;

  bool changingCategory = false;

  StaggeredGridView scene;

  List tabs = ["Dog", "Cat"];

  @override
  void initState() {
    super.initState();
    // 请求网络数据
    requestForAllBreeds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void scrollToTop() {}

  void requestForAllBreeds() {
    // 直接开始请求数据
    DogApi.getAllBreeds().then((onValue) {
      this.setState(() {
        this.breeds = onValue as AllBreeds;
      });
      // 请求完类型数据之后, 要请求图片信息, 先随机挑选一个
      this.selectedIdx = Random().nextInt(this.breeds.names.length);
      String breed = this.breeds.names[this.selectedIdx];
      // 根据这个类别去取对应的图片
      this.reuqestForIndicateBreed(breed);
    });
  }

  void reuqestForIndicateBreed(String breed) {
    // 下面数据的加载
    DogApi.getImageWithBreed(breed).then((onValue) {
      if (this.changingCategory) {
        this.changingCategory = false;
      }
      this.setState(() {
        this.isLoading = false;
        this.breedImgs = onValue as DogImageForIndicateBreed;
        print("Dog-请求指定品种完成: $breed");
      });
    });
  }

  // 界面的返回控件
  @override
  Widget build(BuildContext context) {
    Widget scene;
    if (this.isLoading) {
      scene = this.buildLoadingScene();
    } else {
      scene = this.buildImgScene();
    }
    return scene;
  }

  // 全局加载界面
  Widget buildLoadingScene() {
    return ProgressDialog(loading: this.isLoading);
  }

  // 构建展示局部加载
  Widget buildChangeCategory() {
    return new Container(
      color: Colors.white,
      child: new Center(
        child: new CupertinoActivityIndicator(),
      ),
    );
  }

  // 构建PickerView
  Widget buildPicker() {
    new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[],
        ),
      ],
    );
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      color: Color.fromRGBO(0, 0, 0, 0.6),
      child: new CupertinoPicker.builder(
          backgroundColor: Colors.transparent,
          itemExtent: 44,
          childCount: this.breeds.names.length,
          onSelectedItemChanged: (int selected) {
            this.formerSelected = this.selectedIdx;
            this.setState(() {
              this.selectedIdx = selected;
            });
          },
          itemBuilder: (context, index) {
            return new Container(
              width: 140,
              height: 20,
              alignment: Alignment.center,
              child: new Text(
                this.breeds.names[index],
                textAlign: TextAlign.right,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none),
              ),
            );
          }),
    );
    new GridView.builder(gridDelegate: null, itemBuilder: null);
  }

  // 构建内容布局
  Widget buildImgScene() {
    Widget scene = new StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      itemCount: this.breedImgs != null ? this.breedImgs.imgs.length : 0,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      crossAxisCount: 3,
      itemBuilder: (context, index) {
        return new GestureDetector(
          onTap: () {
            // 执行路由到详情页
            // TODO: 取出当前点击的然后所有往后的
            List<String> unreadImgs = new List<String>();
            for (int i = index; i < this.breedImgs.imgs.length; i++) {
              unreadImgs.add(this.breedImgs.imgs[i]);
            }
            AnimalImagesPage photoPage = new AnimalImagesPage(
              listImages: unreadImgs,
              breed: this.breeds.names[this.selectedIdx],
              imgType: "Dog",
            );
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return photoPage;
            }));
          },
          child: new Container(
            width: 100,
            height: 100,
            color: Color(0xFF2FC77D), //Colors.blueAccent,
            child: new CachedNetworkImage(
              imageUrl: this.breedImgs.imgs[index],
              fit: BoxFit.fill,
              placeholder: (context, index) {
                return new Center(child: new CupertinoActivityIndicator());
              },
            ),
          ),
        );
      },
      // 该属性可以控制当前 Cell 占用的空间大小, 用来实现瀑布的感觉
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(1, index.isEven ? 1.5 : 1),
    );
    if (this.isLoading) {
      scene = this.buildLoadingScene();
    }
    if (this.changingCategory) {
      scene = this.buildChangeCategory();
    }
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2FC77D),
        title: new Text(this.breeds.names[this.selectedIdx]),
        actions: <Widget>[
          // 右边的按钮
          new IconButton(
            key: categoryKey,
            icon: Icon(
              Icons.find_replace,
              color: Colors.white,
            ),
            onPressed: () {
              if (this.breeds != null) {
                RenderBox renderBox =
                    this.categoryKey.currentContext.findRenderObject();
                var offset =
                    renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
                // 获取到了下方位置, 生成选择控件
                this.setState(() {
                  this.pickerPosition = new Offset(
                      offset.dx + renderBox.size.width / 2.0, offset.dy);
                });
                // 直接展示选择控件
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return new MXPicker(this.breeds.names, (selected) {
                      }, (int selected) {
                        this.setState(() {
                          this.selectedIdx = selected;
                        });
                        // 请求新的数据
                        this.reuqestForIndicateBreed(
                            this.breeds.names[this.selectedIdx]);
                        this.setState(() {
                          this.changingCategory = true;
                        });
                      });
                    });
              }
            },
          )
        ],
      ),
      body: NotificationListener<ChangeCategoryNotification>(
        child: new Stack(
          children: <Widget>[
            scene,
          ],
        ),
        onNotification: (ChangeCategoryNotification notification) {
          // 加载新的数据
          this.reuqestForIndicateBreed(this.breeds.names[notification.index]);
          this.setState(() {
            // 设置点击位置为空
            this.pickerPosition = null;
            this.changingCategory = true;
            // 修改标题, 并重新加载
            this.selectedIdx = notification.index;
          });
        },
      ),
    );
  }
}
