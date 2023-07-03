import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'badget.dart';
import '../models/repository.dart';

class RepositoryItem extends StatelessWidget {
  const RepositoryItem({Key? key, required this.repository}) : super(key: key);

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(repository.owner.avatarUrl),
        ),
        GestureDetector(
          child: Text(
            repository.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
          ),
          onTap: () async {
            final url = Uri.parse(repository.htmlUrl);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
          },
        ),
        Text(
          repository.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badget(
              icon: Icons.star,
              label: "Stars",
              value: "${repository.stargazersCount}",
              labelColor: const Color(0xfff7b05b),
              valueColor: const Color(0xffc68d49),
            ),
            const SizedBox(width: 8),
            Badget(
              icon: Icons.visibility_rounded,
              label: "Watching",
              value: "${repository.watchersCount}",
              labelColor: const Color(0xff23967F),
              valueColor: const Color(0xff196959),
            ),
            const SizedBox(width: 8),
            Badget(
              icon: Icons.call_split,
              label: "Forks",
              value: "${repository.forks}",
              labelColor: const Color(0xff8075FF),
              valueColor: const Color(0xff5a52b3),
            ),
          ],
        )
      ],
    );
  }
}
