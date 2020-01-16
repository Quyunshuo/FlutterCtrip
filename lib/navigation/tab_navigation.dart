import 'package:flutter/material.dart';
import 'package:flutter_ctrip/pages/home_page.dart';
import 'package:flutter_ctrip/pages/my_page.dart';
import 'package:flutter_ctrip/pages/search_page.dart';
import 'package:flutter_ctrip/pages/travel_page.dart';

///主体部分
///
///[StatefulWidget],可变状态Widget
class TabNavigation extends StatefulWidget {
  @override
  _TabNavigationState createState() => _TabNavigationState();
}

class _TabNavigationState extends State<TabNavigation> {
  ///页面控制器 设置首次创建[PageView]时显示的页面
  final PageController _controller = PageController(initialPage: 0);

  ///默认颜色
  final _defaultColor = Colors.grey;

  ///选中颜色
  final _activeColor = Colors.blue;

  ///当前页面的索引
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //脚手架
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterCtrip'),
      ),
      //类似于Android中的ViewPage
      body: PageView(
        //页面控制器
        controller: _controller,
        //当PageView被改变时触发该方法 联动底部导航按钮改变
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        //显示的页面
        children: <Widget>[HomePage(), SearchPage(), TravelPage(), MyPage()],
      ),
      //底部导航栏
      bottomNavigationBar: BottomNavigationBar(
          //当前索引
          currentIndex: _currentIndex,
          //点击时
          onTap: (index) {
            //跳转到相应页面
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          //将底部按钮固定住
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                //默认icon
                icon: Icon(Icons.home, color: _defaultColor),
                //选中icon
                activeIcon: Icon(Icons.home, color: _activeColor),
                title: Text(
                  '首页',
                  style: TextStyle(
                      color: _currentIndex != 0 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: _defaultColor),
                activeIcon: Icon(Icons.search, color: _activeColor),
                title: Text(
                  '搜索',
                  style: TextStyle(
                      color: _currentIndex != 1 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt, color: _defaultColor),
                activeIcon: Icon(Icons.camera_alt, color: _activeColor),
                title: Text(
                  '首页',
                  style: TextStyle(
                      color: _currentIndex != 2 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: _defaultColor),
                activeIcon: Icon(Icons.account_circle, color: _activeColor),
                title: Text(
                  '首页',
                  style: TextStyle(
                      color: _currentIndex != 3 ? _defaultColor : _activeColor),
                )),
          ]),
    );
  }
}
