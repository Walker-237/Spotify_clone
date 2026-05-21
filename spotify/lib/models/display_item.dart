import 'package:flutter/material.dart';
import 'track.dart';
import 'album.dart';

class DisplayItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Color color;
  final List<Track> tracks;

  const DisplayItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.tracks,
  });

  factory DisplayItem.fromAlbum(SpotifyAlbum a) => DisplayItem(
        id: a.id,
        title: a.title,
        description: a.description,
        imageUrl: a.imageUrl,
        color: a.color,
        tracks: a.tracks,
      );
}