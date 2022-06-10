class User {
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

  int id;
  String login;
  String avatarUrl;
  String htmlUrl;
  String type;
  int? followers;
  int? following;
  int? publicRepos;
  int? publicGists;

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
