import 'package:flutter/material.dart';
import '../data/spotify_data.dart';
import '../models/display_item.dart';
import '../widgets/asset_or_net_img.dart';
import '../utils/nav_helpers.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greeting = h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening';

    return CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: const Color(0xFF121212),
        floating: true, snap: true, elevation: 0, titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(greeting, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
            Row(children: [
              _iconCircle(Icons.notifications_outlined),
              const SizedBox(width: 8),
              _iconCircle(Icons.access_time_outlined),
              const SizedBox(width: 8),
              _iconCircle(Icons.settings_outlined),
            ]),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RecentGrid(items: SpotifyData.recentlyPlayed),
            const SizedBox(height: 32),
            HSection(title: 'Made For You',  items: SpotifyData.madeForYou),
            const SizedBox(height: 32),
            HSection(title: 'Top Charts',    items: SpotifyData.topCharts),
            const SizedBox(height: 32),
            HSection(title: 'New Releases',  items: SpotifyData.newReleases),
            const SizedBox(height: 130),
          ]),
        ),
      ),
    ]);
  }

  Widget _iconCircle(IconData icon) => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(color: const Color(0xFF282828), borderRadius: BorderRadius.circular(16)),
    child: Icon(icon, color: Colors.white, size: 18),
  );
}

class RecentGrid extends StatelessWidget {
  final List<DisplayItem> items;
  const RecentGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final display = items.take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3.8),
      itemCount: display.length,
      itemBuilder: (ctx, i) => RecentTile(item: display[i]),
    );
  }
}

class RecentTile extends StatelessWidget {
  final DisplayItem item;
  const RecentTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF282828),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => pushDisplayItem(context, item),
        child: Row(children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            child: AssetOrNetImg(url: item.imageUrl, size: 48),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 4),
        ]),
      ),
    );
  }
}

class HSection extends StatelessWidget {
  final String title;
  final List<DisplayItem> items;
  const HSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        const Text('See all', style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 14),
      SizedBox(
        height: 205,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (ctx, i) => AlbumCard(item: items[i]),
        ),
      ),
    ]);
  }
}

class AlbumCard extends StatelessWidget {
  final DisplayItem item;
  const AlbumCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushDisplayItem(context, item),
      child: SizedBox(
        width: 140,
        height: 205,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AssetOrNetImg(url: item.imageUrl, size: 140),
          ),
          const SizedBox(height: 8),
          Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Expanded(
            child: Text(item.description, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ]),
      ),
    );
  }
}