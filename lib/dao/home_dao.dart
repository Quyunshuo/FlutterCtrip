import 'dart:convert';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:http/http.dart' as http;

const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

///首页接口DA0
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    // 判断是否请求成功
    if (response.statusCode == 200) {
      // 解决中文乱码的问题
      Utf8Decoder utf8decoder = Utf8Decoder();
      // 对返回数据进行解码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      // 让HomeModel进行解析
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
