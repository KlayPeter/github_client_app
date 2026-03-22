class Repo {
  final String name;
  final String description;
  final int stars;

  // 👇 新增
  final String owner;
  final String url;
  final int forks;
  final int issues;
  final String createdAt;
  final String updatedAt;

  Repo({
    required this.name,
    required this.description,
    required this.stars,
    required this.owner,
    required this.url,
    required this.forks,
    required this.issues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      stars: json['stargazers_count'] ?? 0,

      // 👇 解析新增字段
      owner: json['owner']?['login'] ?? '',
      url: json['html_url'] ?? '',
      forks: json['forks_count'] ?? 0,
      issues: json['open_issues_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
