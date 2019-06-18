import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef SelectedIndexChange = void Function(int index);

typedef SubmitSelectedIndex = void Function(int index);

class MXPicker extends StatelessWidget {
  final List<String> names;

  final SelectedIndexChange onSelected;

  final SubmitSelectedIndex submit;

  int selectedIndex;

  MXPicker(this.names, this.onSelected, this.submit) : super();

  @override
  Widget build(BuildContext context) {
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

    return new Container(
        width: MediaQuery.of(context).size.width,
        height: 240,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        child: column);
  }
}

/*
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
                        this.submit();
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
            new Container(
              height: 1,
              color: Colors.white,
            ),
            // Picker
            new Expanded(
                child: new Container(
              width: double.infinity,
              height: 160,
              color: Colors.green,
              child: new CupertinoPicker.builder(
                  backgroundColor: Colors.blue,
                  itemExtent: 44,
                  childCount: this.names.length,
                  onSelectedItemChanged: (int selected) {
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
            ))
          ],
        ),
      ],
    );
* */
/**
 *
    new Container(
    height: 200,
    child: new CupertinoPicker.builder(
    backgroundColor: Colors.transparent,
    itemExtent: 44,
    childCount: this.names.length,
    onSelectedItemChanged: (int selected) {
    this.onSelected(selected);
    },
    itemBuilder: (context, index) {
    return new Container(
    width: 140,
    height: 20,
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

    Widget stack = new Stack(fit: StackFit.expand, children: <Widget>[
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
    this.submit();
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
    new Container(
    height: 1,
    color: Colors.white,
    ),
    // picker
    new Container(
    width: MediaQuery.of(context).size.width,
    height: 160,
    child: new ListView.builder(
    itemCount: this.names.length,
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
    ),
    ],
    )
    ]);
    return stack;
 */
