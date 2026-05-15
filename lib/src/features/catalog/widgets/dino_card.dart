import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/dino_model.dart';

class DinoCard extends StatelessWidget {
  const DinoCard({super.key, required this.dino, required this.onTap});

  final DinoModel dino;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Hero(
                tag: 'dino-image-${dino.id}',
                child: _Thumbnail(url: dino.thumbnailUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dino.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dino.clade,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholderColor =
        Theme.of(context).colorScheme.surfaceContainerHighest;
    if (url == null || url!.isEmpty) {
      return _Placeholder(color: placeholderColor);
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      memCacheWidth: 480,
      placeholder: (_, _) => _Placeholder(color: placeholderColor),
      errorWidget: (_, _, _) => _Placeholder(color: placeholderColor),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Icon(
        Icons.pets,
        size: 36,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
