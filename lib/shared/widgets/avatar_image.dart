import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const AvatarImage({super.key, this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        width: radius,
        height: radius,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (_, __, ___) => Container(
          width: radius,
          height: radius,
          color: const Color(0xFFFFDCBE),
          child: Center(
            child: Icon(Icons.person, size: radius, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}