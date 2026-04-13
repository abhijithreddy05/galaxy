import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';
import 'package:shimmer/shimmer.dart';

class PinGridItem extends StatelessWidget {
  final PinEntity pin;
  final String heroTagPrefix;

  const PinGridItem({Key? key, required this.pin, this.heroTagPrefix = 'home_'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String heroTag = '\${heroTagPrefix}pin_image_\${pin.id}';
    return GestureDetector(
      onTap: () {
        context.push('/pin', extra: {'pin': pin, 'heroTag': heroTag});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: pin.imageUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: (pin.height / pin.width) * (MediaQuery.of(context).size.width / 2),
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              pin.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
