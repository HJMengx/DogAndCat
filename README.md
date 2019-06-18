---
title: Flutter: 完成一个图片APP
---

自从 `Flutter` 推出之后, 一直是备受关注, 有看好的也有不看好的, 作为移动开发人员自然是要尝试一下的(但是它的嵌套写法真的难受), 本着学一个东西, 就一定要动手的态度, 平时又喜欢看一些猫狗的图片, 就想着做一个加载猫狗图片你的 APP, 界面图如下(界面不是很好看).

![](file.gif)

#### 主要模块

![](https://user-gold-cdn.xitu.io/2019/6/18/16b6a3b4592018e8?w=1989&h=1080&f=jpeg&s=141138)


##### NetWork

`api.dart`文件中, 分别定义了`DogApi, CatApi`两个类, 一个用于处理获取猫的图片的类, 一个用于处理狗的图片的类.

`http_request.dart`文件封装了`Http`请求, 用于发送和接收数据.

`url.dart`文件封装了需要用到的`Api`接口, 主要是为了方便和统一管理而编写.

`Models`文件夹下分别定义不同`API`接口返回数据的模型. 

##### 图片页

瀑布流使用的`flutter_staggered_grid_view`库, 作者自定义了`Delegate`计算布局, 使用起来非常简单.

```Dart
Widget scene = new StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      itemCount: this.breedImgs != null ? this.breedImgs.urls.length : 0,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      crossAxisCount: 3,
      itemBuilder: (context, index) {
        return new GestureDetector(
          onTapUp: (TapUpDetails detail) {
            // 展示该品种的相关信息
            dynamic breed = this.breeds[this.selectedIdx].description;
            // TODO: 取出当前点击的然后所有往后的
            List<String> unreadImgs = new List<String>();
            for (int i = index; i < this.breedImgs.urls.length; i++) {
              unreadImgs.add(this.breedImgs.urls[i]);
            }
            AnimalImagesPage photoPage = new AnimalImagesPage(
              listImages: unreadImgs,
              breed: this.breeds[this.selectedIdx].name,
              imgType: "Cat",
              petInfo: this.breeds[this.selectedIdx],
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
              imageUrl: this.breedImgs.urls[index],
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
```

* 组装`PickerView`

系统默认的 `PickerView` 在每一次切换都会回调, 而且没有确定和取消事件, 
如果直接使用会造成频繁的网络请求, 内存消耗也太快, 所以组装了一下, 增加确定和取消才去执行网络请求, 这样就解决了这个问题.

```Dart
    Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: new GestureDetector(
                      onTapUp: (detail) {
                        // 点击了确定按钮, 退出当前页面
                        Navigator.of(context).pop();
                        // 回调操作
                        this.submit(this.selectedIndex);
                      },
                      child: new Text(
                        "确定",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: new GestureDetector(
                      onTapUp: (detail) {
                        // 点击了确定按钮, 退出当前页面
                        Navigator.of(context).pop();
                      },
                      child: new Text(
                        "取消",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        new Container(
          height: 1,
          color: Colors.white,
        ),
        // Picker
        new Expanded(
          child: new CupertinoPicker.builder(
              backgroundColor: Colors.transparent,
              itemExtent: 44,
              childCount: this.names.length,
              onSelectedItemChanged: (int selected) {
                this.selectedIndex = selected;
                this.onSelected(selected);
              },
              itemBuilder: (context, index) {
                return new Container(
                  width: 160,
                  height: 44,
                  alignment: Alignment.center,
                  child: new Text(
                    this.names[index],
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none),
                  ),
                );
              }),
        )
      ],
    );
```

##### 详情页

* `Column` 包含 `ListView`

详情页中, 上方是一个图片, 下方是关于品种的相关信息, `猫`下方是通过 `API`获取到的属性进行一个展示, 需要注意一点是, 如果`Column`封装了`MainAxis`相同方向的滚动控件, 必须设置`Width/Height`, 同理, `Row`也是需要注意这一点的.

我在这里的做法是通过一个`Container`包裹 `ListView`.

```Dart
new Container(
    margin: EdgeInsets.only(bottom: 10, top: 10),
    height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width / 1.2 - 80,
     width: MediaQuery.of(context).size.width,
     child: listView,
),
```

* 图片动画

这一部分稍微复杂一些, 首先需要监听滑动的距离, 来对图片进行变换, 最后根据是否达到阈值来进行切换动画, 这里我没有实现在最后一张和第一张图片进行切换以至于可以无限循环滚动, 我在边界阈值上只是阻止了下一步动画.

动画我都是通过`Matrix4`来设置不同位置的属性, 它也能模拟出 `3D` 效果, 

动画的变换都是`Tween`来管理.

```Dart
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
    // 第三个值是角度
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
```

`Widget`引用这个属性来执行动画.

```Dart 
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
```

###### Firebase_admob

**注意: 这里需要去 firebase 官网注册 APP, 然后分别下载 iOS, Android 的配置文件放到指定的位置, 否则程序启动的时候会闪退.**

**iOS info.plist: GADApplicationIdentifier也需要配置, 虽然在 Dart 中会启动的时候就注册ID, 但是这里也别忘了配置.**

**Android Manifst.xml 也需要配置**

```xml
<meta-data
 android:name="com.google.android.gms.ads.APPLICATION_ID"
 android:value=""/>
```

`这里说一下我因为个人编码导致的问题, 我尝试自己来控制广告展示, 加了一个读秒跳过按钮(想强制观看一段时间), 点击跳过设置setState, 但是在 build 方法中又请求了广告, 导致了一个死循环, 最后由于请求次数过多还没有设置自己的设备为测试设备也不是使用的测试ID, 账号被暂停了, 所以大家使用的时候要避免这个问题, 尽量还是将自己的设备添加到测试设备中.`

使用的话比较简单(官方的演示代码直接复制也可以用).

```Dart
class AdPage {
  MobileAdTargetingInfo targetingInfo;

  InterstitialAd interstitial;

  BannerAd banner;

  void initAttributes() {
    if (this.targetingInfo == null) {
      this.targetingInfo = MobileAdTargetingInfo(
          keywords: ["some keyword for your app"],
          // 防止被Google 认为是无效点击和展示.
          testDevices: ["Your Phone", "Simulator"]);

      bool android = Platform.isAndroid;

      this.interstitial = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: this.targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            // 点击关闭
            print("InterstitialAd Closed");
            this.interstitial.dispose();
            this.interstitial = null;
          } else if (event == MobileAdEvent.clicked) {
            // 关闭
            print("InterstitialAd Clicked");
            this.interstitial.dispose();
            this.interstitial = null;
          } else if (event == MobileAdEvent.loaded) {
            // 加载
            print("InterstitialAd Loaded");
          }
          print("InterstitialAd event is $event");
        },
      );

//      this.banner = BannerAd(
//          targetingInfo: this.targetingInfo,
//          size: AdSize.smartBanner,
//          listener: (MobileAdEvent event) {
//            if (event == MobileAdEvent.closed) {
//              // 点击关闭
//              print("InterstitialAd Closed");
//              this.interstitial.dispose();
//              this.interstitial = null;
//            } else if (event == MobileAdEvent.clicked) {
//              // 关闭
//              print("InterstitialAd Clicked");
//              this.interstitial.dispose();
//              this.interstitial = null;
//            } else if (event == MobileAdEvent.loaded) {
//              // 加载
//              print("InterstitialAd Loaded");
//            }
//            print("InterstitialAd event is $event");
//          });
    }
  }

  @override
  void show() {
    // 初始化数据
    this.initAttributes();
    // 然后控制跳转
    if (this.interstitial != null) {
      this.interstitial.load();
      this.interstitial.show(
            anchorType: AnchorType.bottom,
            anchorOffset: 0.0,
          );
    }
  }
}
```


项目比较简单, 但是编写的过程中也遇到了许多问题, 慢慢解决的过程也学到了挺多.


#### 一些资源

[Public APIs](https://github.com/HJMengx/public-apis)

[代码地址](https://github.com/HJMengx/DogAndCat/)
