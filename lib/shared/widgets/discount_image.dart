import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DiscountImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;

  const DiscountImage({
    super.key,
    required this.imageUrl,
    this.width = 110,
    this.height = 110,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) =>
        const Icon(
          Icons.broken_image,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}