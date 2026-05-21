import 'package:flutter/material.dart';
import '../data/spotify_data.dart';
import '../models/display_item.dart';
import '../models/album.dart';
import '../widgets/asset_or_net_img.dart';
import '../utils/helpers.dart';
import '../utils/nav_helpers.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _ctrl = TextEditingController();
  String _q = '';

  List<SpotifyAlbum> get _results => _q.isEmpty ? [] :
    SpotifyData.albums.where((a) =>
      a.title.toLowerCase().contains(_q.toLowerCase()) ||
      a.artist.toLowerCase().contains(_q.toLowerCase()) ||
      a.genre.toLowerCase().contains(_q.toLowerCase())
    ).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('Search', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _q = v),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Artists, songs, or podcasts',
              hintStyle: const TextStyle(color: Colors.black45),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: _q.isNotEmpty
                ? GestureDetector(onTap: () { _ctrl.clear(); setState(() => _q = ''); }, child: const Icon(Icons.close, color: Colors.black54))
                : null,
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        Expanded(child: _q.isNotEmpty ? _buildResults() : _buildBrowse()),
      ]),
    );
  }

  Widget _buildResults() {
    final r = _results;
    if (r.isEmpty) return const Center(child: Text('No results', style: TextStyle(color: Colors.white60, fontSize: 16)));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: r.length,
      itemBuilder: (ctx, i) {
        final a = r[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => pushDisplayItem(ctx, DisplayItem.fromAlbum(a)),
          leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: AssetOrNetImg(url: a.imageUrl, size: 52)),
          title: Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text('${a.artist} · ${a.genre}', style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12)),
          trailing: const Icon(Icons.more_vert, color: Color(0xFFB3B3B3)),
        );
      },
    );
  }

  Widget _buildBrowse() {
    final genres = SpotifyData.genres;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: Text('Browse all', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2.1),
          itemCount: genres.length,
          itemBuilder: (_, i) {
            final g = genres[i];
            return Container(
              decoration: BoxDecoration(color: parseColor(g['color']!), borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(12),
              child: Text(g['name']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
            );
          },
        ),
      ),
    ]);
  }
}