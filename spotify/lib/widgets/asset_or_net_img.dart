import 'package:flutter/material.dart';

class AssetOrNetImg extends StatelessWidget {
  final String url;
  final double size;
  final BoxFit fit;
  const AssetOrNetImg({super.key, required this.url, required this.size, this.fit = BoxFit.cover});

  bool get _isNetwork => url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final w = size == double.infinity ? null : size;
    final h = size == double.infinity ? null : size;

    Widget fallback = Container(
      width: w, height: h,
      color: const Color(0xFF282828),
      child: const Icon(Icons.music_note, color: Colors.white54),
    );

    if (_isNetwork) {
      return Image.network(
        url, width: w, height: h, fit: fit,
        loadingBuilder: (_, child, prog) => prog == null ? child : Container(width: w, height: h, color: const Color(0xFF282828), child: const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954), strokeWidth: 2))),
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return Image.asset(
      url, width: w, height: h, fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}