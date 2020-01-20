import 'package:dio/dio.dart';
import 'package:flutter_ctrip/model/home_model.dart';

const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

///首页接口
class HomeDao {
  static Future<HomeModel> fetch() async {
    Response response = await Dio().get(HOME_URL);
    if (response.statusCode == 200) {
      return HomeModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
