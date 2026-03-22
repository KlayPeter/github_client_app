import 'package:flutter/material.dart';
import '../models/repo.dart';

class DetailPage extends StatelessWidget {
  final Repo repo;

  const DetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(repo.name)),
      body: SingleChildScrollView(
        // ✅ 防止内容溢出
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 仓库名 =====
            Text(
              repo.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // ===== 作者 =====
            Text(
              '作者：${repo.owner}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // ===== 描述 =====
            Text(
              repo.description.isEmpty ? '暂无描述' : repo.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // ===== 数据统计 =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Icons.star, 'Stars', repo.stars),
                _buildStat(Icons.call_split, 'Forks', repo.forks),
                _buildStat(Icons.error_outline, 'Issues', repo.issues),
              ],
            ),

            const SizedBox(height: 20),

            // ===== 时间信息 =====
            Text('创建时间：${repo.createdAt}'),
            const SizedBox(height: 6),
            Text('更新时间：${repo.updatedAt}'),

            const SizedBox(height: 20),

            // ===== 仓库地址 =====
            Text('仓库地址：', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            SelectableText(
              repo.url,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  /// 小组件：统计项（星星 / fork / issue）
  Widget _buildStat(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 4),
        Text('$value'),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
