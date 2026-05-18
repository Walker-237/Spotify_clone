import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/spotify_data.dart';
import '../models/display_item.dart';
import '../models/album.dart';
import '../models/track.dart';
import '../pages/category_page.dart';
import '../widgets/asset_or_net_img.dart';
import '../utils/nav_helpers.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _ctrl = TextEditingController();
  late final List<_DiscoverItem> _discoverItems;
  String _q = '';

  @override
  void initState() {
    super.initState();
    _discoverItems = _randomDiscoverItems();
  }

  List<SpotifyAlbum> get _results => _q.isEmpty
      ? []
      : SpotifyData.albums
            .where(
              (a) =>
                  a.title.toLowerCase().contains(_q.toLowerCase()) ||
                  a.artist.toLowerCase().contains(_q.toLowerCase()) ||
                  a.genre.toLowerCase().contains(_q.toLowerCase()),
            )
            .toList();

  List<_DiscoverItem> _randomDiscoverItems() {
    final items = SpotifyData.albums
        .expand(
          (album) => album.tracks.map(
            (track) => _DiscoverItem(
              track: track,
              tag: '#${album.genre.toLowerCase().replaceAll(' ', '')}',
            ),
          ),
        )
        .toList();
    items.shuffle(math.Random());
    return items.take(8).toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => setState(() => _q = v),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'What do you want to listen to?',
                hintStyle: const TextStyle(color: Colors.black45),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                ),
                suffixIcon: _q.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _ctrl.clear();
                          setState(() => _q = '');
                        },
                        child: const Icon(Icons.close, color: Colors.black54),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          Expanded(child: _q.isNotEmpty ? _buildResults() : _buildBrowse()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final r = _results;
    if (r.isEmpty) {
      return const Center(
        child: Text(
          'No results',
          style: TextStyle(color: Colors.white60, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: r.length,
      itemBuilder: (ctx, i) {
        final a = r[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => pushDisplayItem(ctx, DisplayItem.fromAlbum(a)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AssetOrNetImg(url: a.imageUrl, size: 52),
          ),
          title: Text(
            a.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${a.artist} · ${a.genre}',
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
          ),
          trailing: const Icon(Icons.more_vert, color: Color(0xFFB3B3B3)),
        );
      },
    );
  }

  Widget _buildBrowse() {
    final categories = SpotifyData.searchCategories;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _DiscoverSection(items: _discoverItems),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Text(
              'Browse all',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.66,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _BrowseCategoryCard(category: categories[i]),
              childCount: categories.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscoverItem {
  final Track track;
  final String tag;

  const _DiscoverItem({required this.track, required this.tag});
}

class _DiscoverSection extends StatelessWidget {
  final List<_DiscoverItem> items;

  const _DiscoverSection({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 2, 16, 18),
          child: Text(
            'Discover something new',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => _DiscoverCard(item: items[i]),
          ),
        ),
      ],
    );
  }
}

class _DiscoverCard extends StatelessWidget {
  final _DiscoverItem item;

  const _DiscoverCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetOrNetImg(
              url: item.track.imageUrl,
              size: 170,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x66000000),
                    Color(0xE6000000),
                  ],
                  stops: [0.28, 0.62, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                item.tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrowseCategoryCard extends StatelessWidget {
  final SpotifyCategory category;

  const _BrowseCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.color,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CategoryPage(category: category)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              right: 76,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              right: -16,
              bottom: -14,
              child: CategoryCover(category: category),
            ),
          ],
        ),
      ),
    );
  }
}
