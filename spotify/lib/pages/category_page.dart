import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/spotify_data.dart';
import '../models/display_item.dart';
import '../utils/nav_helpers.dart';
import '../widgets/asset_or_net_img.dart';

class CategoryPage extends StatelessWidget {
  final SpotifyCategory category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final sections = SpotifyData.sectionsForCategory(category);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: category.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _CategoryHero(category: category),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 0, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final section in sections) ...[
                    _CategorySectionView(section: section),
                    const SizedBox(height: 42),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHero extends StatelessWidget {
  final SpotifyCategory category;

  const _CategoryHero({required this.category});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AssetOrNetImg(
          url: category.heroImageUrl,
          size: double.infinity,
          fit: BoxFit.cover,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withValues(alpha: 0.88),
                category.color.withValues(alpha: 0.55),
                const Color(0xFF121212),
              ],
              stops: const [0.0, 0.48, 1.0],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.18),
                const Color(0xFF121212),
              ],
              stops: const [0.0, 0.58, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 28,
          child: Text(
            category.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CategorySectionView extends StatelessWidget {
  final CategorySection section;

  const _CategorySectionView({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              section.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: section.items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return _CategoryItemCard(item: section.items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryItemCard extends StatelessWidget {
  final DisplayItem item;

  const _CategoryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushDisplayItem(context, item),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  AssetOrNetImg(url: item.imageUrl, size: 150),
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: FaIcon(
                      FontAwesomeIcons.spotify,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCover extends StatelessWidget {
  final SpotifyCategory category;

  const CategoryCover({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 11,
      child: Container(
        width: 94,
        height: 94,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AssetOrNetImg(url: category.imageUrl, size: 94),
        ),
      ),
    );
  }
}
