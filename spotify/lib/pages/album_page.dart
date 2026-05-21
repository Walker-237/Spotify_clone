import 'package:flutter/material.dart';
import '../models/display_item.dart';
import '../state/player_state.dart';
import '../widgets/asset_or_net_img.dart';
import 'now_playing_page.dart';
import '../utils/nav_helpers.dart';

class AlbumPage extends StatefulWidget {
  final DisplayItem item;
  const AlbumPage({super.key, required this.item});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  bool _liked = false;
  String _fmt(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final p = widget.item;
    final totalMin = p.tracks.fold<int>(0, (s, t) => s + t.duration.inMinutes);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 340, pinned: true, backgroundColor: p.color,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              AssetOrNetImg(url: p.imageUrl, size: double.infinity, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, p.color.withOpacity(0.5), const Color(0xFF121212)],
                    stops: const [0.35, 0.68, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 16, left: 16, right: 16,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text(p.description, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('${p.tracks.length} songs · $totalMin min', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ]),
              ),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(children: [
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? const Color(0xFF1DB954) : Colors.grey, size: 28),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.more_vert, color: Colors.grey, size: 26),
              const Spacer(),
              ListenableBuilder(
                listenable: player,
                builder: (_, __) => GestureDetector(
                  onTap: player.toggleShuffle,
                  child: Icon(Icons.shuffle, color: player.isShuffle ? const Color(0xFF1DB954) : Colors.grey, size: 26),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (p.tracks.isEmpty) return;
                  player.play(p.tracks.first, trackList: p.tracks);
                  Navigator.push(context, slideRoute(NowPlayingPage(track: p.tracks.first)));
                },
                child: Container(
                  width: 56, height: 56,
                  decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 32),
                ),
              ),
            ]),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final track = p.tracks[i];
              return ListenableBuilder(
                listenable: player,
                builder: (_, __) {
                  final active = player.currentTrack?.id == track.id;
                  return ListTile(
                    onTap: () {
                      player.play(track, trackList: p.tracks);
                      Navigator.push(ctx, slideRoute(NowPlayingPage(track: track)));
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: ClipRRect(borderRadius: BorderRadius.circular(2), child: AssetOrNetImg(url: track.imageUrl, size: 46)),
                    title: Text(track.title, style: TextStyle(color: active ? const Color(0xFF1DB954) : Colors.white, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(track.artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(_fmt(track.duration), style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                      const SizedBox(width: 8),
                      const Icon(Icons.more_vert, color: Color(0xFFB3B3B3), size: 18),
                    ]),
                  );
                },
              );
            },
            childCount: p.tracks.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ]),
    );
  }
}