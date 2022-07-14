import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'badget.dart';
import 'contexts/user_context.dart';
import 'models/user.dart';

class UserItem extends ReactterComponent<UserContext> {
  const UserItem({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  get builder => () => UserContext();

  @override
  get onInit => (ctx) => ctx.user.value = user;

  @override
  Widget render(UserContext ctx, BuildContext context) {
    final user = ctx.user.value;

    if (user == null) return const SizedBox.shrink();

    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          child: Text(
            user.login,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
          ),
          onTap: () async {
            final url = Uri.parse(user.htmlUrl);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badget(
              label: "Followers",
              value: "${user.followers}",
              labelColor: const Color(0xff01579b),
              valueColor: const Color(0xff013d6d),
            ),
            const SizedBox(width: 8),
            Badget(
              label: "Following",
              value: "${user.following}",
              labelColor: const Color(0xff29b6f6),
              valueColor: const Color(0xff1d7fac),
            ),
            const SizedBox(width: 8),
            Badget(
              label: "Repos",
              value: "${user.publicRepos}",
              labelColor: const Color(0xff23967F),
              valueColor: const Color(0xff196959),
            ),
            const SizedBox(width: 8),
            Badget(
              label: "Gists",
              value: "${user.publicGists}",
              labelColor: const Color(0xff8075FF),
              valueColor: const Color(0xff5a52b3),
            ),
          ],
        ),
      ],
    );
  }
}
