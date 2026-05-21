import 'package:flutter/material.dart';
import '../models/track.dart';
import '../state/player_state.dart';
import '../widgets/asset_or_net_img.dart';

class NowPlayingPage extends StatefulWidget {
  final Track track;
  const NowPlayingPage({super.key, required this.track});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  double _seek = 0.3;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    if (!player.isPlaying) _spin.stop();
    player.addListener(_syncSpin);
  }

  void _syncSpin() {
    if (player.isPlaying) { _spin.repeat(); } else { _spin.stop(); }
  }

  @override
  void dispose() { player.removeListener(_syncSpin); _spin.dispose(); super.dispose(); }

  String _fmt(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: player,
      builder: (ctx, _) {
        final t = player.currentTrack ?? widget.track;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [t.accentColor, t.accentColor.withOpacity(0.55), const Color(0xFF0A0A0A)],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(children: [
                    IconButton(icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32), onPressed: () => Navigator.pop(ctx)),
                    const Expanded(child: Center(child: Text('NOW PLAYING', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)))),
                    IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
                  ]),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _spin,
                  builder: (_, child) => Transform.rotate(angle: player.isPlaying ? _spin.value * 6.2832 : 0, child: child),
                  child: Container(
                    width: 270, height: 270,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: t.accentColor.withOpacity(0.7), blurRadius: 48, spreadRadius: 10)]),
                    child: ClipOval(child: AssetOrNetImg(url: t.imageUrl, size: 270)),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.title,  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(t.artist, style: const TextStyle(color: Colors.white60, fontSize: 15)),
                    ])),
                    IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white, size: 28), onPressed: () {}),
                  ]),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    SliderTheme(
                      data: SliderTheme.of(ctx).copyWith(
                        thumbColor: Colors.white,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      ),
                      child: Slider(value: _seek, onChanged: (v) => setState(() => _seek = v)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(_fmt(t.duration * _seek),  style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        Text(_fmt(t.duration),           style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    IconButton(icon: Icon(Icons.shuffle, color: player.isShuffle ? const Color(0xFF1DB954) : Colors.white60, size: 24), onPressed: player.toggleShuffle),
                    IconButton(icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 42), onPressed: player.skipPrev),
                    GestureDetector(
                      onTap: player.togglePlay,
                      child: Container(
                        width: 66, height: 66,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.black, size: 38),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 42), onPressed: player.skipNext),
                    IconButton(icon: Icon(Icons.repeat, color: player.isRepeat ? const Color(0xFF1DB954) : Colors.white60, size: 24), onPressed: player.toggleRepeat),
                  ]),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    IconButton(icon: const Icon(Icons.devices_other, color: Colors.white60, size: 22), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.share_outlined,  color: Colors.white60, size: 22), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.queue_music,     color: Colors.white60, size: 22), onPressed: () {}),
                  ]),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        );
      },
    );
  }
}