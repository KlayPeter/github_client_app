import 'package:flutter/material.dart';
import '../services/github_api.dart';
import '../models/repo.dart';
import '../common/global.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // 构造函数

  @override // 创建状态对象
  State<HomePage> createState() => _HomePageState(); // 返回状态对象
}

class _HomePageState extends State<HomePage> {
  List<Repo> repos = []; // 仓库列表数据
  bool loading = false;
  int page = 1; // 当前页
  bool isLoadingMore = false; // 是否正在加载更多
  final ScrollController _scrollController = ScrollController(); // 滚动控制

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

    // 监听滚动
    _scrollController.addListener(() {
      // 滚动到底部
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // 防止重复触发
        if (!isLoadingMore) {
          page++; // 下一页
          loadData(isLoadMore: true);
        }
      }
    });
  }

  Future loadData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore = true;
    } else {
      setState(() {
        loading = true;
        page = 1; // 刷新时重置页码
      });
    }

    try {
      // 调用 API 获取数据
      final result = await GithubApi.fetchRepos(Global.keyword, page);

      setState(() {
        if (isLoadingMore) {
          repos.addAll(result); // 追加数据
        } else {
          repos = result; //替换数据
        }
      });
    } catch (e) {
      // 出错提示（简单打印）
      print('请求失败: $e');
    } finally {
      setState(() {
        loading = false; // 结束加载
        isLoadMore = false;
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
                : RefreshIndicator(
                    onRefresh: () async {
                      await loadData(); // 下拉刷新时重新加载数据
                    },
                    child: ListView.builder(
                      controller: _scrollController, // 绑定滚动控制器
                      // 否则显示列表
                      itemCount: repos.length + 1, // 多一个用于显示加载更多
                      itemBuilder: (context, index) {
                        // 最后一个显示加载更多
                        if (index == repos.length) {
                          return isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox(); // 没有更多了显示空组件
                        }

                        final repo = repos[index];

                        return GestureDetector(
                          onTap: () {
                            // 页面跳转
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(repo: repo), // 传递数据
                              ),
                            );
                          },
                          child: Card(
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
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
