import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/player_state.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/asset_or_net_img.dart';
import 'pages/home_tab.dart';
import 'pages/search_tab.dart';
import 'pages/library_tab.dart';
import 'pages/now_playing_page.dart';
import 'utils/nav_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SpotifyApp());
}

class SpotifyApp extends StatelessWidget {
  const SpotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF1DB954)),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: Stack(children: [
            IndexedStack(index: _tab, children: const [HomeTab(), SearchTab(), LibraryTab()]),
            if (player.currentTrack != null)
              Positioned(bottom: 0, left: 0, right: 0, child: MiniPlayer()),
          ]),
          bottomNavigationBar: BottomNav(
            selected: _tab,
            onTap: (i) => setState(() => _tab = i),
          ),
        );
      },
    );
  }
}

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = player.currentTrack!;
    return GestureDetector(
      onTap: () => Navigator.push(context, slideRoute(NowPlayingPage(track: t))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        height: 64,
        decoration: BoxDecoration(
          color: t.accentColor.withOpacity(0.96),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.55), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: Row(children: [
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AssetOrNetImg(url: t.imageUrl, size: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.title,  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(t.artist, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ]),
          ),
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white, size: 22), onPressed: () {}),
          IconButton(icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 28), onPressed: player.togglePlay),
          IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 26), onPressed: player.skipNext),
          const SizedBox(width: 4),
        ]),
      ),
    );
  }
}