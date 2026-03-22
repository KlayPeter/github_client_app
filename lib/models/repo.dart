class Repo {
  final String name; // 项目名称
  final String description; // 项目描述
  final int stars; // 项目星标数

  Repo({
    required this.name,
    required this.description,
    required this.stars,
  }); // 构造函数

  // 从 JSON 数据创建 Repo 实例的工厂构造函数
  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      description: json['description'] ?? '',
      stars: json['stargazers_count'] ?? 0,
    );
  }
}
