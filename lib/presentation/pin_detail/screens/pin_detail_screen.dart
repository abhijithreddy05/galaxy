import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/theme/theme.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';

class PinDetailScreen extends StatelessWidget {
  final PinEntity pin;
  final String heroTag;

  const PinDetailScreen({Key? key, required this.pin, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background dismiss handler
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 10) {
                context.pop();
              }
            },
            child: Center(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: CachedNetworkImage(
                    imageUrl: pin.detailUrl,
                    placeholder: (context, url) => Container(color: Colors.grey[800]),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[800]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Top Navigation Elements
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
              onPressed: () => context.pop(),
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
              onPressed: () {},
            ),
          ),

          // Bottom Info & Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pin.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pin.author,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.pinterestRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
