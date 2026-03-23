import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repo.dart';

class GithubApi {
  static Future<List<Repo>> fetchRepos(String keyword, int page) async {
    final url = Uri.parse(
      'https://api.github.com/search/repositories?q=$keyword&page=$page&per_page=20',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List items = data['items'];

      return items.map((item) => Repo.fromJson(item)).toList();
    } else {
      throw Exception('请求失败');
    }
  }
}
