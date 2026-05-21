import 'package:flutter/material.dart';
import '../models/display_item.dart';
import '../models/artist.dart';
import '../pages/album_page.dart';
import '../pages/artist_page.dart';

Route slideRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, __, ___) => page,
  transitionsBuilder: (_, anim, __, child) => SlideTransition(
    position: Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
    child: child,
  ),
  transitionDuration: const Duration(milliseconds: 380),
);

void pushDisplayItem(BuildContext ctx, DisplayItem item) =>
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => AlbumPage(item: item)));

void pushArtist(BuildContext ctx, SpotifyArtist artist) =>
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => ArtistPage(artist: artist)));