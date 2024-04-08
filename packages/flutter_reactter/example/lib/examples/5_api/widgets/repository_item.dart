import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'badget.dart';
import 'package:examples/examples/5_api/models/repository.dart';

class RepositoryItem extends StatelessWidget {
  final Repository repository;

  const RepositoryItem({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(repository.owner.avatarUrl),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Text(
                      repository.fullName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  const SizedBox(height: 8),
                  Text(
                    repository.description,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FittedBox(
          child: Row(
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
                label: "Watchers",
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
          ),
        ),
      ],
    );
  }
}
