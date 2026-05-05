import 'package:flutter/material.dart';

class SpotifyPlaylist {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final Color color;
  final List<String> trackIds;

  const SpotifyPlaylist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.trackIds,
  });
}