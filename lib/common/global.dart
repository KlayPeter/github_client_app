import 'package:shared_preferences/shared_preferences.dart';

class Global {
  // 全局关键词
  static String keyword = "flutter";

  // 本地存储实例
  static late SharedPreferences prefs;

  /// 初始化（必须在 main 里调用）
  static Future init() async {
    prefs = await SharedPreferences.getInstance();

    // 读取本地存储的关键词
    keyword = prefs.getString("keyword") ?? "flutter";
  }
  /// 保存关键词
  static saveKeyword(String value) {
    prefs.setString('keyword', value);
  }
}
