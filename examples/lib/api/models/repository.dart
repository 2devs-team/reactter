import 'user.dart';

class Repository {
  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.owner,
    this.stargazersCount = 0,
    this.watchersCount = 0,
    this.forks = 0,
  });

  int id;
  String name;
  String fullName;
  String description;
  String htmlUrl;
  User owner;
  int? stargazersCount;
  int? watchersCount;
  int? forks;

  factory Repository.fromJson(Map<String, dynamic> json) => Repository(
        id: json["id"],
        name: json["name"],
        fullName: json["full_name"],
        description: json["description"],
        htmlUrl: json["html_url"],
        owner: User.fromJson(json["owner"]),
        stargazersCount: json["stargazers_count"],
        watchersCount: json["watchers_count"],
        forks: json["forks"],
      );
}
