import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:flutter_ctrip/widget/webview.dart';

///本地导航按钮栏的自定义Widget
class LocalNavWidget extends StatelessWidget {
  ///首页接口的[LocalNavList]数据
  final List<LocalNavList> localNavList;

  const LocalNavWidget({Key key, @required this.localNavList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //圆角
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (localNavList == null) return null;

    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      //控制排列方式
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext context, LocalNavList model) {
    return GestureDetector(
      //点击事件
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Image.network(model.icon, width: 32, height: 32),
          Text(model.title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
