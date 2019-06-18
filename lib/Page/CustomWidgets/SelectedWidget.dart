import 'package:flutter/material.dart';

class ChangeCategoryNotification extends Notification {
  final String name;
  final int index;

  ChangeCategoryNotification(this.name, this.index);
}

class SelectedWidget extends StatelessWidget {
  final List<String> allItems;

  final Offset showPosition;

  SelectedWidget(this.allItems, this.showPosition);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(0, 0, 0, 0.6),
//      margin: EdgeInsets.only(right: this.showPosition.dy * 2.0),
      padding: EdgeInsets.only(right: 10),
      child: ListView.builder(
          itemCount: this.allItems.length,
          itemBuilder: (context, index) {
            return new GestureDetector(
                onTapUp: (TapUpDetails detail) {
                  // 点击发送通知, 通知是冒泡的形式
                  print('detail is $detail with $index');
                  ChangeCategoryNotification("DogCategory", index)
                      .dispatch(context);
                },
                child: new Container(
                  width: 50,
                  height: 44,
                  child: new Text(
                    this.allItems[index],
                    textAlign: TextAlign.right,
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ));
          }),
    );
  }
}
