import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../models/display_item.dart';
import '../data/spotify_data.dart';
import '../widgets/asset_or_net_img.dart';
import '../utils/nav_helpers.dart';

class ArtistPage extends StatelessWidget {
  final SpotifyArtist artist;
  const ArtistPage({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final artistAlbums = SpotifyData.albumsForArtist(artist);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 260, pinned: true, backgroundColor: const Color(0xFF282828),
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              AssetOrNetImg(url: artist.imageUrl, size: double.infinity, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xFF121212)],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              Positioned(bottom: 16, left: 16, child: Text(artist.name, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5))),
            ]),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text('Discography', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final a = artistAlbums[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                onTap: () => pushDisplayItem(ctx, DisplayItem.fromAlbum(a)),
                leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: AssetOrNetImg(url: a.imageUrl, size: 56)),
                title: Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('${a.year} · ${a.genre}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                trailing: const Icon(Icons.more_vert, color: Color(0xFFB3B3B3)),
              );
            },
            childCount: artistAlbums.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ]),
    );
  }
}