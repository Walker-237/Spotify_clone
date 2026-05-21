import 'package:flutter/material.dart';

class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final Duration duration;
  final Color accentColor;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.duration,
    required this.accentColor,
  });
}