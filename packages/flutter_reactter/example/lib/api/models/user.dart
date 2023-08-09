class User {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final String type;
  final int? followers;
  final int? following;
  final int? publicRepos;
  final int? publicGists;

  User({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
    this.followers = 0,
    this.following = 0,
    this.publicRepos = 0,
    this.publicGists = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        login: json["login"],
        avatarUrl: json["avatar_url"],
        htmlUrl: json["html_url"],
        type: json["type"],
        followers: json["followers"],
        following: json["following"],
        publicRepos: json["public_repos"],
        publicGists: json["public_gists"],
      );
}
