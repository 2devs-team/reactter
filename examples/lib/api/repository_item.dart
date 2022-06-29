import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'badget.dart';
import 'contexts/repository_context.dart';
import 'models/repository.dart';

class RepositoryItem extends ReactterComponent<RepositoryContext> {
  const RepositoryItem({Key? key, required this.repository}) : super(key: key);

  final Repository repository;

  @override
  get builder => () => RepositoryContext();

  @override
  get onInit => (ctx) => ctx.repository.value = repository;

  @override
  Widget render(RepositoryContext ctx, BuildContext context) {
    final repo = ctx.repository.value;

    if (repo == null) return const SizedBox.shrink();

    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(repo.owner.avatarUrl),
        ),
        GestureDetector(
          child: Text(
            repo.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
          ),
          onTap: () async {
            final url = Uri.parse(repo.htmlUrl);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
          },
        ),
        Text(repo.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badget(
              icon: Icons.star,
              label: "Stars",
              value: repo.stargazersCount.toString(),
              labelColor: const Color(0xfff7b05b),
              valueColor: const Color(0xffc68d49),
            ),
            const SizedBox(width: 8),
            Badget(
              icon: Icons.visibility_rounded,
              label: "Watching",
              value: repo.watchersCount.toString(),
              labelColor: const Color(0xff23967F),
              valueColor: const Color(0xff196959),
            ),
            const SizedBox(width: 8),
            Badget(
              icon: Icons.call_split,
              label: "Forks",
              value: repo.forks.toString(),
              labelColor: const Color(0xff8075FF),
              valueColor: const Color(0xff5a52b3),
            ),
          ],
        )
      ],
    );
  }
}
