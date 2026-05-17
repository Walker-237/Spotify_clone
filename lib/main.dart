import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SportifyApp());
}

// ════════════════════════════════════════════════════════════════════════════
// THEME & APP
// ════════════════════════════════════════════════════════════════════════════

class SportifyApp extends StatelessWidget {
  const SportifyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF1DB954), surface: Color(0xFF121212)),
      ),
      home: const MainScreen(),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════════════

class Song {
  final String id, title, artist, duration, plays;
  const Song({required this.id, required this.title, required this.artist, required this.duration, this.plays = ''});
}

class Album {
  final String id, title, year, type;
  final Color color;
  const Album({required this.id, required this.title, required this.year, this.type = 'Album', required this.color});
}

class MerchItem {
  final String id, name, price;
  final Color color;
  const MerchItem({required this.id, required this.name, required this.price, required this.color});
}

class ArtistModel {
  final String id, name, genre, about, monthlyListeners;
  final Color color;
  final List<Song> popular;
  final List<Album> albums;
  final List<Song> artistPick;
  final List<MerchItem> merch;
  final List<String> featuring;
  final List<String> fansAlsoLike;
  final List<String> playlists;

  const ArtistModel({
    required this.id, required this.name, required this.genre,
    required this.about, required this.monthlyListeners, required this.color,
    required this.popular, required this.albums, required this.artistPick,
    required this.merch, required this.featuring, required this.fansAlsoLike,
    required this.playlists,
  });
}

class Playlist {
  final String id, name, owner;
  final Color color;
  final List<Song> songs;
  const Playlist({required this.id, required this.name, required this.owner, required this.color, required this.songs});
}

// ════════════════════════════════════════════════════════════════════════════
// SAMPLE DATA
// ════════════════════════════════════════════════════════════════════════════

final List<ArtistModel> sampleArtists = [
  ArtistModel(
    id: 'a1', name: 'The Weeknd', genre: 'R&B/Soul', monthlyListeners: '111.2M',
    color: const Color(0xFF880808),
    about: 'Abel Makkonen Tesfaye, known professionally as The Weeknd, is a Canadian singer, songwriter, and record producer. Known for his sonic versatility and dark lyricism, his music explores the darker side of fame and fortune.',
    popular: const [
      Song(id: 's1', title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20', plays: '4.2B'),
      Song(id: 's2', title: 'Save Your Tears', artist: 'The Weeknd', duration: '3:35', plays: '2.8B'),
      Song(id: 's3', title: 'Starboy', artist: 'The Weeknd', duration: '3:50', plays: '2.1B'),
      Song(id: 's4', title: 'Die For You', artist: 'The Weeknd', duration: '4:20', plays: '1.9B'),
      Song(id: 's5', title: 'Call Out My Name', artist: 'The Weeknd', duration: '3:48', plays: '1.5B'),
    ],
    artistPick: const [
      Song(id: 'ap1', title: 'Popular', artist: 'The Weeknd & Playboi Carti', duration: '3:21', plays: '900M'),
    ],
    albums: const [
      Album(id: 'al1', title: 'After Hours', year: '2020', color: Color(0xFF8B0000)),
      Album(id: 'al2', title: 'Starboy', year: '2016', color: Color(0xFF4A148C)),
      Album(id: 'al3', title: 'Dawn FM', year: '2022', color: Color(0xFF0D47A1)),
      Album(id: 'al4', title: 'Kiss Land', year: '2013', color: Color(0xFF1B5E20)),
    ],
    merch: const [
      MerchItem(id: 'm1', name: 'After Hours Hoodie', price: '\$65', color: Color(0xFF8B0000)),
      MerchItem(id: 'm2', name: 'Starboy Tee', price: '\$35', color: Color(0xFF4A148C)),
      MerchItem(id: 'm3', name: 'Dawn FM Cap', price: '\$30', color: Color(0xFF0D47A1)),
    ],
    featuring: ['Blinding Lights (Remix)', 'Popular ft. Playboi Carti', 'Hurricane ft. Kanye West'],
    fansAlsoLike: ['Drake', 'Post Malone', 'Future', 'Nav', 'PartyNextDoor'],
    playlists: ['Late Night Vibes', 'R&B Hits', 'Chill Mix'],
  ),
  ArtistModel(
    id: 'a2', name: 'Taylor Swift', genre: 'Pop', monthlyListeners: '98.4M',
    color: const Color(0xFF1A237E),
    about: 'Taylor Alison Swift is an American singer-songwriter. Her narrative songwriting, which often centers around her personal life, has received widespread critical plaudits and has earned her a broad fanbase.',
    popular: const [
      Song(id: 's6', title: 'Anti-Hero', artist: 'Taylor Swift', duration: '3:20', plays: '3.1B'),
      Song(id: 's7', title: 'Shake It Off', artist: 'Taylor Swift', duration: '3:39', plays: '2.6B'),
      Song(id: 's8', title: 'Blank Space', artist: 'Taylor Swift', duration: '3:51', plays: '2.3B'),
      Song(id: 's9', title: 'Love Story', artist: 'Taylor Swift', duration: '3:55', plays: '1.8B'),
      Song(id: 's10', title: 'Cruel Summer', artist: 'Taylor Swift', duration: '2:58', plays: '2.0B'),
    ],
    artistPick: const [
      Song(id: 'ap2', title: 'The Tortured Poets Department', artist: 'Taylor Swift', duration: '4:02', plays: '800M'),
    ],
    albums: const [
      Album(id: 'al5', title: 'Midnights', year: '2022', color: Color(0xFF1A237E)),
      Album(id: 'al6', title: 'Folklore', year: '2020', color: Color(0xFF37474F)),
      Album(id: 'al7', title: 'Lover', year: '2019', color: Color(0xFFE91E63)),
      Album(id: 'al8', title: '1989', year: '2014', color: Color(0xFF0288D1)),
    ],
    merch: const [
      MerchItem(id: 'm4', name: 'Eras Tour Tee', price: '\$45', color: Color(0xFF1A237E)),
      MerchItem(id: 'm5', name: 'Midnights Hoodie', price: '\$70', color: Color(0xFF4A148C)),
      MerchItem(id: 'm6', name: 'Folklore Vinyl', price: '\$30', color: Color(0xFF37474F)),
    ],
    featuring: ['Both of Us ft. Taylor Swift', 'Highway Don\'t Care', 'Both of Us (Live)'],
    fansAlsoLike: ['Olivia Rodrigo', 'Billie Eilish', 'Ariana Grande', 'Dua Lipa', 'Selena Gomez'],
    playlists: ['Pop Hits', 'Girls Night', 'Feel Good Vibes'],
  ),
  ArtistModel(
    id: 'a3', name: 'Drake', genre: 'Hip-Hop/Rap', monthlyListeners: '75.3M',
    color: const Color(0xFFE65100),
    about: 'Aubrey Drake Graham is a Canadian rapper, singer, and actor. A prominent figure in popular music, Drake is credited for popularizing the Toronto sound and is often regarded as a symbol of the shift in popular music during the 2010s.',
    popular: const [
      Song(id: 's11', title: 'God\'s Plan', artist: 'Drake', duration: '3:19', plays: '2.9B'),
      Song(id: 's12', title: 'Hotline Bling', artist: 'Drake', duration: '4:27', plays: '2.4B'),
      Song(id: 's13', title: 'One Dance', artist: 'Drake', duration: '2:54', plays: '2.2B'),
      Song(id: 's14', title: 'In My Feelings', artist: 'Drake', duration: '3:37', plays: '1.7B'),
      Song(id: 's15', title: 'Started From the Bottom', artist: 'Drake', duration: '3:14', plays: '1.4B'),
    ],
    artistPick: const [
      Song(id: 'ap3', title: 'Rich Flex', artist: 'Drake & 21 Savage', duration: '3:58', plays: '1.1B'),
    ],
    albums: const [
      Album(id: 'al9', title: 'Certified Lover Boy', year: '2021', color: Color(0xFFE65100)),
      Album(id: 'al10', title: 'Scorpion', year: '2018', color: Color(0xFF212121)),
      Album(id: 'al11', title: 'Views', year: '2016', color: Color(0xFF0D47A1)),
      Album(id: 'al12', title: 'Take Care', year: '2011', color: Color(0xFF1B5E20)),
    ],
    merch: const [
      MerchItem(id: 'm7', name: 'OVO Hoodie', price: '\$120', color: Color(0xFFE65100)),
      MerchItem(id: 'm8', name: 'CLB Tour Tee', price: '\$55', color: Color(0xFF212121)),
      MerchItem(id: 'm9', name: 'OVO Cap', price: '\$40', color: Color(0xFF37474F)),
    ],
    featuring: ['Laugh Now Cry Later', 'Life Is Good ft. Drake', 'Greece ft. Drake'],
    fansAlsoLike: ['The Weeknd', '21 Savage', 'Future', 'Lil Baby', 'Kendrick Lamar'],
    playlists: ['OVO Sound', 'Rap Hits', 'Late Night Drive'],
  ),
];

final List<Playlist> samplePlaylists = [
  const Playlist(id: 'pl1', name: 'Liked Songs', owner: 'You', color: Color(0xFF4B2C8C),
    songs: [
      Song(id: 'ls1', title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20'),
      Song(id: 'ls2', title: 'Anti-Hero', artist: 'Taylor Swift', duration: '3:20'),
      Song(id: 'ls3', title: 'God\'s Plan', artist: 'Drake', duration: '3:19'),
    ]),
  const Playlist(id: 'pl2', name: 'Late Night Vibes', owner: 'Spotify', color: Color(0xFF1DB954),
    songs: [
      Song(id: 'lnv1', title: 'Starboy', artist: 'The Weeknd', duration: '3:50'),
      Song(id: 'lnv2', title: 'Hotline Bling', artist: 'Drake', duration: '4:27'),
    ]),
  const Playlist(id: 'pl3', name: 'Pop Hits', owner: 'Spotify', color: Color(0xFFE91E63),
    songs: [
      Song(id: 'ph1', title: 'Shake It Off', artist: 'Taylor Swift', duration: '3:39'),
      Song(id: 'ph2', title: 'One Dance', artist: 'Drake', duration: '2:54'),
    ]),
  const Playlist(id: 'pl4', name: 'Rap Caviar', owner: 'Spotify', color: Color(0xFF212121),
    songs: [
      Song(id: 'rc1', title: 'Rich Flex', artist: 'Drake & 21 Savage', duration: '3:58'),
      Song(id: 'rc2', title: 'Die For You', artist: 'The Weeknd', duration: '4:20'),
    ]),
];

// ════════════════════════════════════════════════════════════════════════════
// MAIN SCREEN + BOTTOM NAV
// ════════════════════════════════════════════════════════════════════════════

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;

  final _screens = const [HomeScreen(), SearchScreen(), YourLibraryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.search_rounded, label: 'Search', index: 1, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.library_music_rounded, label: 'Your Library', index: 2, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 80, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: active ? Colors.white : const Color(0xFFB3B3B3), size: 26),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? Colors.white : const Color(0xFFB3B3B3), fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w400), textAlign: TextAlign.center),
      ])),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MINI PLAYER
// ════════════════════════════════════════════════════════════════════════════

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(4),
            child: Container(width: 40, height: 40, color: const Color(0xFF1DB954), child: const Icon(Icons.music_note, color: Colors.black, size: 22))),
          const SizedBox(width: 10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Blinding Lights', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            Text('The Weeknd', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 11)),
          ])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.devices, color: Color(0xFF1DB954), size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 12),
          IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// YOUR LIBRARY SCREEN (with top tabs: Playlists | Artists)
// ════════════════════════════════════════════════════════════════════════════

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});
  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _PlaylistsTab(isGridView: _isGridView),
              _ArtistsTab(isGridView: _isGridView),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(children: [
        const CircleAvatar(radius: 16, backgroundColor: Color(0xFF535353),
          child: Text('U', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
        const SizedBox(width: 10),
        const Text('Your Library', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white, size: 26), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => setState(() => _isGridView = !_isGridView),
          child: Icon(_isGridView ? Icons.list_rounded : Icons.grid_view_rounded, color: Colors.white, size: 24),
        ),
      ]),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(30)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: const Color(0xFF1DB954), borderRadius: BorderRadius.circular(30)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Playlists'), Tab(text: 'Artists')],
      ),
    );
  }
}

// ─── PLAYLISTS TAB ────────────────────────────────────────────────────────────

class _PlaylistsTab extends StatelessWidget {
  final bool isGridView;
  const _PlaylistsTab({required this.isGridView});

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
        itemCount: samplePlaylists.length,
        itemBuilder: (context, i) => _PlaylistGridCard(playlist: samplePlaylists[i]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: samplePlaylists.length,
      itemBuilder: (context, i) => _PlaylistListTile(playlist: samplePlaylists[i]),
    );
  }
}

class _PlaylistListTile extends StatelessWidget {
  final Playlist playlist;
  const _PlaylistListTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 54, height: 54,
        decoration: BoxDecoration(color: playlist.color, borderRadius: BorderRadius.circular(4)),
        child: playlist.id == 'pl1'
            ? const Icon(Icons.favorite, color: Colors.white, size: 28)
            : const Icon(Icons.music_note, color: Colors.white, size: 28),
      ),
      title: Text(playlist.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text('Playlist • ${playlist.owner}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: playlist))),
    );
  }
}

class _PlaylistGridCard extends StatelessWidget {
  final Playlist playlist;
  const _PlaylistGridCard({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: playlist))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Container(
          decoration: BoxDecoration(color: playlist.color, borderRadius: BorderRadius.circular(6)),
          child: Center(child: playlist.id == 'pl1'
              ? const Icon(Icons.favorite, color: Colors.white, size: 40)
              : const Icon(Icons.music_note, color: Colors.white, size: 40)),
        )),
        const SizedBox(height: 6),
        Text(playlist.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
        Text('Playlist', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 11)),
      ]),
    );
  }
}

// ─── ARTISTS TAB ──────────────────────────────────────────────────────────────

class _ArtistsTab extends StatelessWidget {
  final bool isGridView;
  const _ArtistsTab({required this.isGridView});

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
        itemCount: sampleArtists.length,
        itemBuilder: (context, i) => _ArtistGridCard(artist: sampleArtists[i]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sampleArtists.length,
      itemBuilder: (context, i) => _ArtistListTile(artist: sampleArtists[i]),
    );
  }
}

class _ArtistListTile extends StatelessWidget {
  final ArtistModel artist;
  const _ArtistListTile({required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(radius: 28, backgroundColor: artist.color, child: Text(artist.name[0], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
      title: Text(artist.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text('Artist • ${artist.monthlyListeners} monthly listeners', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtistScreen(artist: artist))),
    );
  }
}

class _ArtistGridCard extends StatelessWidget {
  final ArtistModel artist;
  const _ArtistGridCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtistScreen(artist: artist))),
      child: Column(children: [
        Expanded(child: Container(
          decoration: BoxDecoration(color: artist.color, shape: BoxShape.circle),
          child: Center(child: Text(artist.name[0], style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))),
        )),
        const SizedBox(height: 8),
        Text(artist.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
        const Text('Artist', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 11)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ARTIST SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ArtistScreen extends StatefulWidget {
  final ArtistModel artist;
  const ArtistScreen({super.key, required this.artist});
  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool _isFollowing = false;
  bool _shuffleOn = false;
  bool _showAllSongs = false;

  ArtistModel get a => widget.artist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildFollowRow()),
          SliverToBoxAdapter(child: _buildSectionHeader('Popular')),
          SliverToBoxAdapter(child: _buildPopularSongs()),
          SliverToBoxAdapter(child: _buildArtistPickSection()),
          SliverToBoxAdapter(child: _buildMerchSection()),
          SliverToBoxAdapter(child: _buildDiscographySection()),
          SliverToBoxAdapter(child: _buildFeaturingSection()),
          SliverToBoxAdapter(child: _buildAboutSection()),
          SliverToBoxAdapter(child: _buildFanSupportSection()),
          SliverToBoxAdapter(child: _buildArtistPlaylistsSection()),
          SliverToBoxAdapter(child: _buildFansAlsoLikeSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: a.color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [a.color, a.color.withOpacity(0.7), const Color(0xFF121212)],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            // Artist avatar
            Positioned(
              top: 60, left: 0, right: 0,
              child: Center(
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: a.color,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)]),
                  child: Center(child: Text(a.name[0], style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            // Artist name & listeners
            Positioned(
              bottom: 20, left: 16, right: 16,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.name, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
                const SizedBox(height: 4),
                Text('${a.monthlyListeners} monthly listeners', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ── FOLLOW ROW ────────────────────────────────────────────────────────────

  Widget _buildFollowRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Row(children: [
        GestureDetector(
          onTap: () => setState(() => _isFollowing = !_isFollowing),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: _isFollowing ? const Color(0xFF1DB954) : const Color(0xFFB3B3B3), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_isFollowing ? 'Following' : 'Follow',
              style: TextStyle(color: _isFollowing ? const Color(0xFF1DB954) : Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.more_vert, color: Color(0xFFB3B3B3), size: 26),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() => _shuffleOn = !_shuffleOn),
          child: Icon(Icons.shuffle_rounded, color: _shuffleOn ? const Color(0xFF1DB954) : const Color(0xFFB3B3B3), size: 28),
        ),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 54, height: 54,
            decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 34),
          ),
        ),
      ]),
    );
  }

  // ── POPULAR SONGS ─────────────────────────────────────────────────────────

  Widget _buildPopularSongs() {
    final songs = _showAllSongs ? a.popular : a.popular.take(5).toList();
    return Column(children: [
      ...songs.asMap().entries.map((e) => _PopularSongTile(song: e.value, rank: e.key + 1)),
      TextButton(
        onPressed: () => setState(() => _showAllSongs = !_showAllSongs),
        child: Text(_showAllSongs ? 'Show less' : 'See more', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    ]);
  }

  // ── ARTIST PICK ───────────────────────────────────────────────────────────

  Widget _buildArtistPickSection() {
    return _buildSectionContainer(
      title: "Artist Pick",
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: a.color, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.music_note, color: Colors.white, size: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Artist\'s pick', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(a.artistPick.first.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            Text(a.artistPick.first.artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
          ])),
          const Icon(Icons.play_circle_fill, color: Color(0xFF1DB954), size: 42),
        ]),
      ),
    );
  }

  // ── MERCH ─────────────────────────────────────────────────────────────────

  Widget _buildMerchSection() {
    return _buildSectionContainer(
      title: 'Merch',
      child: SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: a.merch.length,
          itemBuilder: (context, i) {
            final m = a.merch[i];
            return SizedBox(
              width: 140,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 120, width: 140,
                  decoration: BoxDecoration(color: m.color, borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 40)),
                ),
                const SizedBox(height: 6),
                Text(m.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text(m.price, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
              ]),
            );
          },
        ),
      ),
    );
  }

  // ── DISCOGRAPHY ───────────────────────────────────────────────────────────

  Widget _buildDiscographySection() {
    return _buildSectionContainer(
      title: 'Popular Releases',
      actionLabel: 'See discography',
      child: SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: a.albums.length,
          itemBuilder: (context, i) {
            final al = a.albums[i];
            return SizedBox(
              width: 140,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 140, width: 140,
                  decoration: BoxDecoration(color: al.color, borderRadius: BorderRadius.circular(6)),
                  child: const Center(child: Icon(Icons.album, color: Colors.white, size: 44)),
                ),
                const SizedBox(height: 6),
                Text(al.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text('${al.year} • ${al.type}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
              ]),
            );
          },
        ),
      ),
    );
  }

  // ── FEATURING ─────────────────────────────────────────────────────────────

  Widget _buildFeaturingSection() {
    return _buildSectionContainer(
      title: 'Featuring ${a.name}',
      child: Column(
        children: a.featuring.map((f) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.music_note, color: Color(0xFFB3B3B3), size: 20)),
          title: Text(f, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          subtitle: const Text('Single', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
          trailing: const Icon(Icons.more_vert, color: Color(0xFFB3B3B3), size: 18),
        )).toList(),
      ),
    );
  }

  // ── ABOUT ─────────────────────────────────────────────────────────────────

  Widget _buildAboutSection() {
    return _buildSectionContainer(
      title: 'About',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [a.color.withOpacity(0.8), a.color.withOpacity(0.3)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 28, backgroundColor: a.color, child: Text(a.name[0], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${a.monthlyListeners} monthly', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const Text('listeners', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ]),
          const SizedBox(height: 12),
          Text(a.about, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
        ]),
      ),
    );
  }

  // ── FAN SUPPORT ───────────────────────────────────────────────────────────

  Widget _buildFanSupportSection() {
    return _buildSectionContainer(
      title: 'Support ${a.name}',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: a.color, shape: BoxShape.circle),
              child: const Icon(Icons.favorite, color: Colors.white, size: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Support this artist', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              Text('Show your love for ${a.name}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
            ])),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Learn how to help', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── ARTIST PLAYLISTS ──────────────────────────────────────────────────────

  Widget _buildArtistPlaylistsSection() {
    return _buildSectionContainer(
      title: '${a.name}\'s Playlists',
      child: SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: a.playlists.length,
          itemBuilder: (context, i) {
            final colors = [const Color(0xFF1DB954), const Color(0xFF2196F3), const Color(0xFFE91E63)];
            return SizedBox(
              width: 140,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 140, width: 140,
                  decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(6)),
                  child: const Center(child: Icon(Icons.queue_music, color: Colors.white, size: 44)),
                ),
                const SizedBox(height: 6),
                Text(a.playlists[i], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                const Text('Playlist', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
              ]),
            );
          },
        ),
      ),
    );
  }

  // ── FANS ALSO LIKE ────────────────────────────────────────────────────────

  Widget _buildFansAlsoLikeSection() {
    return _buildSectionContainer(
      title: 'Fans Also Like',
      child: SizedBox(
        height: 170,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemCount: a.fansAlsoLike.length,
          itemBuilder: (context, i) {
            final colors = [const Color(0xFF880808), const Color(0xFFE65100), const Color(0xFF1A237E), const Color(0xFF2E7D32), const Color(0xFF6A1B9A)];
            return SizedBox(
              width: 100,
              child: Column(children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: colors[i % colors.length], shape: BoxShape.circle),
                  child: Center(child: Text(a.fansAlsoLike[i][0], style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 6),
                Text(a.fansAlsoLike[i], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                const Text('Artist', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 11)),
              ]),
            );
          },
        ),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, {String? actionLabel}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        const Spacer(),
        if (actionLabel != null)
          Text(actionLabel, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child, String? actionLabel}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader(title, actionLabel: actionLabel),
      child,
    ]);
  }
}

// ─── POPULAR SONG TILE ────────────────────────────────────────────────────────

class _PopularSongTile extends StatelessWidget {
  final Song song;
  final int rank;
  const _PopularSongTile({required this.song, required this.rank});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: SizedBox(
        width: 36,
        child: Center(child: Text('$rank', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 15, fontWeight: FontWeight.w600))),
      ),
      title: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
      subtitle: Text(song.plays.isNotEmpty ? song.plays : song.artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(song.duration, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
        const SizedBox(width: 8),
        const Icon(Icons.more_vert, color: Color(0xFFB3B3B3), size: 18),
      ]),
      onTap: () {},
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PLAYLIST DETAIL SCREEN
// ════════════════════════════════════════════════════════════════════════════

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;
  const PlaylistDetailScreen({super.key, required this.playlist});
  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  bool _isFollowing = false;
  bool _shuffleOn = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.playlist;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: p.color,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Container(decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [p.color, p.color.withOpacity(0.6), const Color(0xFF121212)], stops: const [0.0, 0.6, 1.0]))),
                Center(child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(width: 150, height: 150,
                    decoration: BoxDecoration(color: p.color, borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 8))]),
                    child: Center(child: p.id == 'pl1' ? const Icon(Icons.favorite, color: Colors.white, size: 64) : const Icon(Icons.music_note, color: Colors.white, size: 64))),
                )),
              ]),
            ),
          ),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('Playlist • ${p.owner} • ${p.songs.length} songs', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13)),
            ]),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(children: [
              const Icon(Icons.arrow_circle_down_outlined, color: Color(0xFFB3B3B3), size: 28),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => setState(() => _isFollowing = !_isFollowing),
                child: Icon(_isFollowing ? Icons.favorite : Icons.favorite_border, color: _isFollowing ? const Color(0xFF1DB954) : const Color(0xFFB3B3B3), size: 28),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _shuffleOn = !_shuffleOn),
                child: Icon(Icons.shuffle_rounded, color: _shuffleOn ? const Color(0xFF1DB954) : const Color(0xFFB3B3B3), size: 28),
              ),
              const SizedBox(width: 14),
              Container(width: 54, height: 54, decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 36)),
            ]),
          )),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, i) {
              final s = p.songs[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.music_note, color: Color(0xFFB3B3B3), size: 20)),
                title: Text(s.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                subtitle: Text(s.artist, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(s.duration, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, color: Color(0xFFB3B3B3), size: 18),
                ]),
              );
            },
            childCount: p.songs.length,
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PLACEHOLDER SCREENS
// ════════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const SafeArea(child: Center(child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))));
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const SafeArea(child: Center(child: Text('Search', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))));
}