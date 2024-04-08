import 'package:examples/examples/5_api/models/user.dart';

class Repository {
  final int id;
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final User owner;
  final int? stargazersCount;
  final int? watchersCount;
  final int? forks;

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
