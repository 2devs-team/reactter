class User {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final String? name;
  final String? bio;
  final String type;
  final int? followers;
  final int? following;
  final int? publicRepos;
  final int? publicGists;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
    this.name,
    this.bio,
    this.followers = 0,
    this.following = 0,
    this.publicRepos = 0,
    this.publicGists = 0,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        login: json["login"],
        avatarUrl: json["avatar_url"],
        htmlUrl: json["html_url"],
        name: json["name"],
        bio: json["bio"],
        type: json["type"],
        followers: json["followers"],
        following: json["following"],
        publicRepos: json["public_repos"],
        publicGists: json["public_gists"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
      );
}
