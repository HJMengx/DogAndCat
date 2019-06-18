import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double TabHeight = 46.0;
const double TextAndIconTabHeight = 72.0;

class MXTab extends StatelessWidget {

  /** 宽 */
  final double width;

  /** 高 */
  final double height;

  /** 高亮状态下的显示 */
  final Widget highLight;

  /** 正常状态下的显示 */
  final Widget normal;

  /** 标题 */
  final String title;

  /** 标题风格, 类型, 正常状态下 */
  final TextStyle titleNormalStyle;

  /** 标题风格, 类型, 高亮状态下 */
  final TextStyle titleHighLightStyle;

  /** 如果存在Icon, 就设置它的 Padding */
  final EdgeInsetsGeometry iconPadding;

  /** 整个 Tab 的Padding */
  final EdgeInsetsGeometry padding;

  /** 子控件的大小 */
  final Size widgetSize;

  /** 背景颜色 */
  final Color bgColor;

  /** 是否被选中 */
  final bool isSelected;

  /** 未处理信息的数目 */
  final Widget badge;
  final int bageNumber;
  final Color bageColor;

  MXTab(
      this.normal,
      this.highLight,
      this.title,
      this.widgetSize,
      this.bgColor,
      this.titleHighLightStyle,
      this.isSelected,
      this.padding,
      this.width,
      this.height,
      this.iconPadding,
      this.titleNormalStyle,
      this.badge,
      this.bageColor,
      {this.bageNumber: 0});

  /** 创建文本 */
  Widget _buildLabelText() {
    Widget state;

    if (this.isSelected) {
      state = this.highLight;
    } else {
      state = this.normal;
    }

    return state ??
        Text(
          this.title,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: this.isSelected
              ? this.titleHighLightStyle
              : this.titleNormalStyle,
        );
  }

  /** 创建数字提示 */
  Widget _buildBadge() {
    if (badge == null && (this.bageNumber == null)) {
      return Container();
    }
    if (badge != null) {
      return badge;
    }
    return Container(
      width: 24,
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: this.bageColor ?? Colors.redAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        this.bageNumber.toString(),
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 没有设置 padding, 就给默认值
    EdgeInsets tabPadding = this.padding;
    if (this.padding == null) {
      tabPadding = EdgeInsets.fromLTRB(10, 0, 10, 0);
    }
    // IconPadding, 如果没有设置, 就设置默认值
    EdgeInsets childPadding = this.iconPadding;
    if (this.iconPadding == null) {
      childPadding = EdgeInsets.all(0);
    }
    // 其他控件的初始化
    double newHeight;
    // 文案, 或者图标
    Widget label;
    // 是否有图标
    Widget state;
    if (this.isSelected) {
      state = this.highLight;
    } else {
      state = this.normal;
    }

    if (this.normal == null || this.highLight == null) {
      newHeight = TabHeight;
      label = _buildLabelText();
    } else if (this.title == null) {
      newHeight = TabHeight;
      label = this.normal;
    } else {
      newHeight = TextAndIconTabHeight;
      label = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: state,
              padding: childPadding,
            ),
            _buildLabelText()
          ]);
    }

    return Container(
      padding: padding ?? EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: this.width,
      color: this.bgColor ?? Colors.transparent,
      child: SizedBox(
        height: this.height ?? newHeight,
        child: Center(
          child: Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(right: 4, top: 4, child: _buildBadge()),
              Container(
                width: this.width,
                child: label,
              ),
            ],
          ),
          widthFactor: 1.0,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', this.title, defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget>('icon', this.normal, defaultValue: null));
  }
}
