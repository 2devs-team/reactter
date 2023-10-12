import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';
import 'badget.dart';

class UserItem extends StatelessWidget {
  final User user;

  const UserItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text(
                        user.login,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    Text(
                      user.name ?? '-',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (user.createdAt != null)
                      Text(
                        "Joined ${DateFormat.yMMMEd().format(user.createdAt!)}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    if (user.bio != null) Text(user.bio!),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FittedBox(
          child: Row(
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
        ),
      ],
    );
  }
}
