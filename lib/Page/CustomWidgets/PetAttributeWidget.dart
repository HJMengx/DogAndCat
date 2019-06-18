import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetAttributeWidget extends StatelessWidget {
  final String attributeName;
  final int degree;

  PetAttributeWidget({this.attributeName, this.degree})
      : assert(attributeName != null),
        assert(degree != null);

  Widget buildDegreeWidget() {
    List<Widget> degrees = new List<Widget>();
    for (int index = 0; index < 5; index++) {
      if ((index + 1) < this.degree) {
        degrees.add(new Icon(
          Icons.star,
          color: Colors.lightBlue,
        ));
      } else {
        degrees.add(new Icon(
          Icons.star_border,
          color: Colors.lightBlue,
        ));
      }
    }
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: degrees,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 名字信息
          new Padding(
            padding: EdgeInsets.only(left: 10),
            child: new Text(
              this.attributeName,
              style: new TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          // 属性程度
          new Padding(
            padding: EdgeInsets.only(right: 10),
            child: this.buildDegreeWidget(),
          )
        ],
      ),
    );
  }
}
