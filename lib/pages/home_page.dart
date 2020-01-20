import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ctrip/dao/home_dao.dart';
import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:flutter_ctrip/widget/local_nav.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// AppBar的滚动最大距离
const APPBAR_SCROLL_OFFSET = 100;

/// Home页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 轮播图的URL地址
  List _imageUrls = [
    'https://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  /// 顶部AppBar的透明度
  double _appBarAlpha = 0.0;

  /// 从服务器请求到的结果
  String resultString = '';

  /// 本地导航按钮栏的数据
  List<CommonModel> localNavList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  ///获取服务端数据
  loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
      });
    } catch (e) {
      print(e);
    }
  }

  /// 滑动监听的处理
  /// [offset]滚动的逻辑像素
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    //对alpha值进行校正
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
    print(_appBarAlpha);
  }

  /// [MediaQuery.removePadding]
  /// 由于ListView会有一个自带的padding 在刘海屏适配上会自动留出顶部的空白
  /// 所以我们这里使用了[MediaQuery.removePadding]来移除了这个padding
  /// [NotificationListener]监听列表的滚动
  /// [Stack]后面的元素会叠加在前面元素的上面
  /// [Opacity]可以改变元素的透明度
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            // 移除顶部的padding
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                // 对滑动监听进行过滤: 有效的列表滚动且是第0个元素(也就是ListView的滚动监听)
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
                return true;
              },
              child: ListView(
                children: <Widget>[
                  Container(
                      height: 160,
                      // 轮播图BannerWidget
                      child: Swiper(
                        itemCount: _imageUrls.length,
                        // 自动播放
                        autoplay: true,
                        // 设置item
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.fill,
                          );
                        },
                        // 添加指示器
                        pagination: SwiperPagination(),
                      )),
                  //本地导航按钮栏
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    child: LocalNavWidget(localNavList: localNavList),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(
                      title: Text(resultString),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
            //透明度
            opacity: _appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
