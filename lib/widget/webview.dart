import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5/'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {Key key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webViewReference = FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;

  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  bool exiting = false;

  @override
  void initState() {
    super.initState();
    //防止页面重新打开
    webViewReference.close();
    //注册Url更改监听
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    //状态监听
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              //防止WebView返回到上一级页面 使用webViewReference.launch打开当前页面
              webViewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        case WebViewState.startLoad:
          break;
        case WebViewState.finishLoad:
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
    //网络错误的监听
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  _isToMain(String url) {
    print(url);
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    super.dispose();
    //及时将注册的监听取消
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onUrlChanged.cancel();
    //关闭所有流
    webViewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///如果没有设置颜色就显示白色
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';

    ///返回按钮的颜色
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          //填充剩余空间
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              //是否可缩放
              withZoom: true,
              //是否启用缓存 本地存储
              withLocalStorage: true,
              //加载过程是否隐藏
              hidden: true,
              //初始化加载中显示的等待界面
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('Waiting'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    //判断是否隐藏AppBar 默认是不隐藏的
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      //可以撑满屏幕的宽度
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close, color: backButtonColor, size: 26),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
