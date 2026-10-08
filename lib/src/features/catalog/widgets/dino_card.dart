import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../data/dino_model.dart';

class DinoCard extends StatelessWidget {
  const DinoCard({super.key, required this.dino, required this.onTap});

  final DinoModel dino;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '${dino.name}${dino.clade != null ? ', ${dino.clade}' : ''}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'dino-image-${dino.id}',
                      child: _Thumbnail(url: dino.thumbnailUrl),
                    ),
                    if (dino.clade != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _CladeBadge(clade: dino.clade!),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Text(
                  dino.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CladeBadge extends StatelessWidget {
  const _CladeBadge({required this.clade});

  final String clade;

  @override
  Widget build(BuildContext context) {
    final color = cladeColor(clade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(100),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        clade,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
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
        Icons.egg_alt_rounded,
        size: 48,
        color: Theme.of(context).colorScheme.primary.withAlpha(160),
      ),
    );
  }
}
