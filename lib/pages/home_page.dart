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

    // ✅ 保存到本地
    Global.saveKeyword(keyword);

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
                  ),
                ),

                const SizedBox(width: 10), // 间距
                // 搜索按钮
                ElevatedButton(
                  onPressed: handleSearch, // 点击事件
                  child: const Text('搜索'),
                ),
              ],
            ),
          ),

          // 列表区域
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator()) // 加载中显示指示器
                // 空数据判断
                : repos.isEmpty
                ? const Center(
                    child: Text(
                      '暂无数据，试试换个关键词 👀',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    // 否则显示列表
                    itemCount: repos.length,
                    itemBuilder: (context, index) {
                      final repo = repos[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        elevation: 3, // 阴影
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 仓库名
                              Text(
                                repo.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // 描述
                              Text(
                                repo.description.isEmpty
                                    ? '暂无描述'
                                    : repo.description,
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 10),

                              // 星星数
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${repo.stars}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
