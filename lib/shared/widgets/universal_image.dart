import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UniversalImage extends StatelessWidget {
  final String source;
  final BoxFit fit;

  const UniversalImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
  });

  bool get _isUrl {
    return source.startsWith('http://') || source.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return _isUrl
        ? CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      placeholder: (_, __) => Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => _errorWidget(),
    )
        : Image.file(
      File(source),
      fit: fit,
      errorBuilder: (_, __, ___) => _errorWidget(),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      ),
    );
  }
}

