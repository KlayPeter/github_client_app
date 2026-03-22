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

  // 输入框控制器（用来获取输入内容）
  final TextEditingController _controller = TextEditingController();

  @override
  // 组件初始化时调用，加载数据
  void initState() {
    super.initState(); // 调用父类的 initState 方法

    // 初始化输入框默认值（用全局关键词）
    _controller.text = Global.keyword;

    // 页面加载时请求一次数据
    loadData();
  }

  Future loadData() async {
    setState(() {
      loading = true; // 开始加载
    });

    try {
      // 调用 API 获取数据
      final result = await GithubApi.fetchRepos(Global.keyword);

      setState(() {
        repos = result; // 更新列表数据
      });
    } catch (e) {
      // 出错提示（简单打印）
      print('请求失败: $e');
    } finally {
      setState(() {
        loading = false; // 结束加载
      });
    }
  }

  // 点击进行搜素
  void handleSearch() {
    // 获取输入框内容
    String keyword = _controller.text;

    if (keyword.isEmpty) {
      // 输入为空提示（简单打印）
      print('请输入搜索关键词');
      return;
    }

    // 更新全局关键词
    Global.keyword = keyword;

    // 重新加载数据
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repositories')), // 应用栏标题
      // 根据 loading 状态显示加载指示器或列表
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // 输入框
                Expanded(
                  child: TextField(
                    controller: _controller, // 绑定控制器
                    decoration: const InputDecoration(
                      hintText: '输入关键词，比如 flutter',
                      border: OutlineInputBorder(),
                    ),
                  )
                ),

                const SizedBox(width: 10), // 间距

                // 搜索按钮
                ElevatedButton(
                  onPressed: handleSearch, // 点击事件
                  child: const Text('搜索'),
                )
              ],
            ),
          ),

          // 列表区域
          Expanded(
            child: loading ? const Center(child: CircularProgressIndicator()) // 加载中显示指示器
              : ListView.builder( // 否则显示列表
                itemCount: repos.length,
                    itemBuilder: (context, index) {
                      final repo = repos[index];

                      return ListTile(
                        title: Text(repo.name),
                        subtitle: Text(repo.description),
                        trailing: Text('⭐ ${repo.stars}'),
                      );
                    },
              )
            )
        ],
      ),
    );
  }
}
