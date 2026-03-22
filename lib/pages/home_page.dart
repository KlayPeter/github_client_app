import 'package:flutter/material.dart';
import '../services/github_api.dart';
import '../models/repo.dart';
import '../common/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // 构造函数

  @override // 创建状态对象
  State<HomePage> createState() => _HomePageState(); // 返回状态对象
}

class _HomePageState extends State<HomePage> {
  List<Repo> repos = []; // 仓库列表数据
  bool loading = false;

  @override
  // 组件初始化时调用，加载数据
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    setState(() {
      loading = true; // 开始加载
    });

    final result = await GithubApi.fetchRepos(Global.keyword); // 调用 API 获取数据

    setState(() {
      repos = result; // 将数据赋值给 repos
      loading = false; // 加载完成
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repositories')), // 应用栏标题
      // 根据 loading 状态显示加载指示器或列表
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repo = repos[index]; // 获取当前项目
          // 构建列表项显示项目名称、描述和星标数
          return ListTile(
            title: Text(repo.name),
            subtitle: Text(repo.description),
            trailing: Text('⭐ ${repo.stars}'),
          );
        },
      )
    );
  }
}
