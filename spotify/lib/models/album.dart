import 'package:flutter/material.dart';
import 'track.dart';

class SpotifyAlbum {
  final String id;
  final String title;
  final String artist;
  final String year;
  final String genre;
  final Color color;
  final String imageUrl;
  final List<Track> tracks;

  const SpotifyAlbum({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.genre,
    required this.color,
    required this.imageUrl,
    required this.tracks,
  });

  String get description => '$artist · $year';
}