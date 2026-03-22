import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'common/global.dart';

void main() {
  // 确保Flutter环境初始化完成（必须在调用任何Flutter API之前调用）
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化全局变量
  Global.init();
  // 运行Flutter应用
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}
