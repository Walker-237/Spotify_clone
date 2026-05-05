import 'package:flutter/material.dart';
import '../data/spotify_data.dart';
import '../models/display_item.dart';
import '../widgets/asset_or_net_img.dart';
import '../utils/nav_helpers.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});
  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  final _filters = ['Albums', 'Artists', 'Playlists'];
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(children: [
            const CircleAvatar(backgroundColor: Color(0xFF535353), radius: 16, child: Icon(Icons.person, color: Colors.white, size: 18)),
            const SizedBox(width: 10),
            const Text('Your Library', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const Spacer(),
            const Icon(Icons.search, color: Colors.white, size: 26),
            const SizedBox(width: 14),
            const Icon(Icons.add, color: Colors.white, size: 26),
          ]),
        ),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final on = _filter == i;
              return GestureDetector(
                onTap: () => setState(() => _filter = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: on ? Colors.white : const Color(0xFF282828), borderRadius: BorderRadius.circular(20)),
                  child: Text(_filters[i], style: TextStyle(color: on ? Colors.black : Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: _buildList(context)),
      ]),
    );
  }

  Widget _buildList(BuildContext context) {
    if (_filter == 1) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: SpotifyData.artists.length,
        itemBuilder: (ctx, i) {
          final artist = SpotifyData.artists[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            onTap: () => pushArtist(ctx, artist),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF282828),
              child: ClipOval(child: AssetOrNetImg(url: artist.imageUrl, size: 56)),
            ),
            title: Text(artist.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Row(children: [
              const Icon(Icons.person, color: Color(0xFFB3B3B3), size: 12),
              const SizedBox(width: 4),
              Text('Artist · ${artist.genres.join(', ')}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
            ]),
          );
        },
      );
    }

    final albums = SpotifyData.savedAlbums;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: albums.length,
      itemBuilder: (ctx, i) {
        final a = albums[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          onTap: () => pushDisplayItem(ctx, DisplayItem.fromAlbum(a)),
          leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: AssetOrNetImg(url: a.imageUrl, size: 56)),
          title: Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Row(children: [
            const Icon(Icons.album, color: Color(0xFFB3B3B3), size: 12),
            const SizedBox(width: 4),
            Expanded(child: Text('${a.genre} · ${a.artist}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        );
      },
    );
  }
}