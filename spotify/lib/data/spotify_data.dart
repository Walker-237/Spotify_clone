import 'package:flutter/material.dart';
import '../models/track.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/display_item.dart';
import '../utils/helpers.dart';

class SpotifyCategory {
  final String name;
  final Color color;
  final String imageUrl;
  final String heroImageUrl;

  const SpotifyCategory({
    required this.name,
    required this.color,
    required this.imageUrl,
    required this.heroImageUrl,
  });
}

class CategorySection {
  final String title;
  final List<DisplayItem> items;

  const CategorySection({required this.title, required this.items});
}

class SpotifyData {
  static final List<SpotifyAlbum> albums = _buildAlbums();

  static List<SpotifyAlbum> _buildAlbums() {
    final raw = _rawAlbums;
    return raw.map((a) {
      final color = parseColor(a['color'] as String);
      final imageUrl = a['imageUrl'] as String;
      final artist = a['artist'] as String;
      final title = a['title'] as String;
      final tracks = (a['tracks'] as List).map((t) {
        return Track(
          id: t['id'] as String,
          title: t['title'] as String,
          artist: artist,
          album: title,
          imageUrl: imageUrl,
          duration: parseDuration(t['duration'] as String),
          accentColor: color,
        );
      }).toList();
      return SpotifyAlbum(
        id: a['id'] as String,
        title: title,
        artist: artist,
        year: a['year'] as String,
        genre: a['genre'] as String,
        color: color,
        imageUrl: imageUrl,
        tracks: tracks,
      );
    }).toList();
  }

  static SpotifyAlbum? albumById(String id) {
    try {
      return albums.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  static Track? trackById(String trackId) {
    final parts = trackId.split('-');
    if (parts.length < 2) return null;
    final albumId = parts[0];
    final album = albumById(albumId);
    if (album == null) return null;
    try {
      return album.tracks.firstWhere((t) => t.id == trackId);
    } catch (_) {
      return null;
    }
  }

  static List<Track> tracksForIds(List<String> ids) =>
      ids.map(trackById).whereType<Track>().toList();

  static final List<SpotifyArtist> artists = _rawArtists.map((a) {
    return SpotifyArtist(
      id: a['id'] as String,
      name: a['name'] as String,
      imageUrl: a['imageUrl'] as String,
      albumIds: List<String>.from(a['albumIds'] as List),
      genres: List<String>.from(a['genres'] as List),
    );
  }).toList();

  static List<SpotifyAlbum> albumsForArtist(SpotifyArtist artist) =>
      artist.albumIds.map(albumById).whereType<SpotifyAlbum>().toList();

  static final List<String> _favouriteArtistIds = [
    'a-2',
    'a-7',
    'a-8',
    'a-12',
    'a-6',
    'a-4',
    'a-1',
  ];

  static List<SpotifyArtist> get favouriteArtists => _favouriteArtistIds
      .map((id) {
        try {
          return artists.firstWhere((a) => a.id == id);
        } catch (_) {
          return null;
        }
      })
      .whereType<SpotifyArtist>()
      .toList();

  static final List<Map<String, String>> _recentlyPlayedRaw = [
    {'type': 'album', 'id': '2'},
    {'type': 'album', 'id': '4'},
    {'type': 'album', 'id': '13'},
    {'type': 'album', 'id': '18'},
    {'type': 'album', 'id': '1'},
    {'type': 'album', 'id': '7'},
  ];

  static List<DisplayItem> get recentlyPlayed => _recentlyPlayedRaw
      .map((r) {
        if (r['type'] == 'album') {
          final a = albumById(r['id']!);
          return a != null ? DisplayItem.fromAlbum(a) : null;
        }
        return null;
      })
      .whereType<DisplayItem>()
      .toList();

  static List<DisplayItem> get madeForYou => [
    _mfyItem(
      'mfy-1',
      'Daily Mix 1',
      'The Weeknd, SZA and more',
      albumById('1')?.imageUrl ?? '',
      const Color(0xFFB71C1C),
      ['1-9', '4-9', '1-2', '4-2', '1-7'],
    ),
    _mfyItem(
      'mfy-2',
      'Daily Mix 2',
      'Kendrick Lamar, Drake and more',
      albumById('2')?.imageUrl ?? '',
      const Color(0xFF4A148C),
      ['2-8', '18-12', '2-2', '19-5', '20-5'],
    ),
    _mfyItem(
      'mfy-3',
      'Daily Mix 3',
      'Nekfeu, Josman and more',
      albumById('24')?.imageUrl ?? '',
      const Color(0xFF212121),
      ['24-1', '22-1', '25-1', '23-2', '26-1'],
    ),
    _mfyItem(
      'mfy-4',
      'Discover Weekly',
      'Fresh picks for you',
      albumById('21')?.imageUrl ?? '',
      const Color(0xFF1B5E20),
      ['21-2', '30-2', '16-2'],
    ),
    _mfyItem(
      'mfy-5',
      'Release Radar',
      'New music from artists you follow',
      albumById('35')?.imageUrl ?? '',
      const Color(0xFF006064),
      ['35-1', '35-2', '34-1'],
    ),
  ];

  static DisplayItem _mfyItem(
    String id,
    String title,
    String desc,
    String img,
    Color color,
    List<String> trackIds,
  ) => DisplayItem(
    id: id,
    title: title,
    description: desc,
    imageUrl: img,
    color: color,
    tracks: tracksForIds(trackIds),
  );

  static List<DisplayItem> get topCharts => ['5', '4', '3', '7', '10']
      .map(albumById)
      .whereType<SpotifyAlbum>()
      .map(DisplayItem.fromAlbum)
      .toList();

  static List<DisplayItem> get newReleases => ['35', '34', '8', '9', '11']
      .map(albumById)
      .whereType<SpotifyAlbum>()
      .map(DisplayItem.fromAlbum)
      .toList();

  static final List<SpotifyCategory> searchCategories = [
    SpotifyCategory(
      name: 'Pop',
      color: const Color(0xFFE91E63),
      imageUrl: _categoryImage('pop.jpg'),
      heroImageUrl: _categoryImage('pop.jpg'),
    ),
    SpotifyCategory(
      name: 'Hip-Hop',
      color: const Color(0xFF9C27B0),
      imageUrl: _categoryImage('hip-hop.jpg'),
      heroImageUrl: _categoryImage('hip-hop.jpg'),
    ),
    SpotifyCategory(
      name: 'R&B',
      color: const Color(0xFF3F51B5),
      imageUrl: _categoryImage('rnb.jpg'),
      heroImageUrl: _categoryImage('rnb.jpg'),
    ),
    SpotifyCategory(
      name: 'Reggaeton',
      color: const Color(0xFF009688),
      imageUrl: _categoryImage('reggaeton.jpg'),
      heroImageUrl: _categoryImage('reggaeton.jpg'),
    ),
    SpotifyCategory(
      name: 'Rock',
      color: const Color(0xFFFF5722),
      imageUrl: _categoryImage('rock.jpg'),
      heroImageUrl: _categoryImage('rock.jpg'),
    ),
    SpotifyCategory(
      name: 'Electronic',
      color: const Color(0xFF00BCD4),
      imageUrl: _categoryImage('electronic.jpg'),
      heroImageUrl: _categoryImage('electronic.jpg'),
    ),
    SpotifyCategory(
      name: 'Jazz',
      color: const Color(0xFF795548),
      imageUrl: _categoryImage('jazz.jpg'),
      heroImageUrl: _categoryImage('jazz.jpg'),
    ),
    SpotifyCategory(
      name: 'Classical',
      color: const Color(0xFF607D8B),
      imageUrl: _categoryImage('classical.jpg'),
      heroImageUrl: _categoryImage('classical.jpg'),
    ),
    SpotifyCategory(
      name: 'Afrobeats',
      color: const Color(0xFF1B5E20),
      imageUrl: _categoryImage('afrobeats.jpg'),
      heroImageUrl: _categoryImage('afrobeats.jpg'),
    ),
    SpotifyCategory(
      name: 'French Rap',
      color: const Color(0xFF212121),
      imageUrl: _categoryImage('french-rap.jpg'),
      heroImageUrl: _categoryImage('french-rap.jpg'),
    ),
    SpotifyCategory(
      name: 'K-Pop',
      color: const Color(0xFF008CDE),
      imageUrl: _categoryImage('k-pop.jpg'),
      heroImageUrl: _categoryImage('k-pop.jpg'),
    ),
    SpotifyCategory(
      name: 'Lo-Fi',
      color: const Color(0xFF37474F),
      imageUrl: _categoryImage('lo-fi.jpg'),
      heroImageUrl: _categoryImage('lo-fi.jpg'),
    ),
  ];

  static String _categoryImage(String fileName) =>
      'assets/images/search categories/$fileName';

  static List<CategorySection> sectionsForCategory(SpotifyCategory category) {
    final allItems = _itemsForCategory(category.name);
    final releases = _releaseItemsForCategory(category.name);
    final essentials = _essentialItemsForCategory(category);

    return [
      CategorySection(title: 'All Things ${category.name}', items: allItems),
      CategorySection(title: 'New ${category.name} Releases', items: releases),
      CategorySection(title: '${category.name} Essentials', items: essentials),
    ].where((section) => section.items.isNotEmpty).toList();
  }

  static List<DisplayItem> _itemsForCategory(String name) {
    switch (name) {
      case 'Pop':
        return _itemsFromAlbumIds(['3', '6', '8', '10', '29']);
      case 'Hip-Hop':
        return _itemsFromAlbumIds([
          '2',
          '7',
          '12',
          '13',
          '14',
          '15',
          '16',
          '18',
          '19',
          '20',
          '21',
        ]);
      case 'R&B':
        return _itemsFromAlbumIds(['1', '4', '11', '32', '33']);
      case 'Reggaeton':
        return _itemsFromAlbumIds(['5']);
      case 'Afrobeats':
        return _itemsFromAlbumIds(['30']);
      case 'French Rap':
        return _itemsFromAlbumIds([
          '22',
          '23',
          '24',
          '25',
          '26',
          '27',
          '28',
          '31',
        ]);
      case 'Lo-Fi':
        return _itemsFromAlbumIds(['29']);
      default:
        return [_categoryMixForName(name)];
    }
  }

  static List<DisplayItem> _releaseItemsForCategory(String name) {
    switch (name) {
      case 'Pop':
        return _itemsFromAlbumIds(['8', '10', '3']);
      case 'Hip-Hop':
        return _itemsFromAlbumIds(['35', '34', '17', '13', '14']);
      case 'R&B':
        return _itemsFromAlbumIds(['33', '32', '4']);
      case 'Reggaeton':
        return _itemsFromAlbumIds(['5']);
      case 'Afrobeats':
        return _itemsFromAlbumIds(['30']);
      case 'French Rap':
        return _itemsFromAlbumIds(['28', '27', '23', '31']);
      case 'Lo-Fi':
        return _itemsFromAlbumIds(['29']);
      default:
        return [_categoryMixForName(name, release: true)];
    }
  }

  static List<DisplayItem> _essentialItemsForCategory(
    SpotifyCategory category,
  ) {
    final base = _itemsForCategory(category.name);
    final mixes = <DisplayItem>[_categoryMixForName(category.name)];
    if (base.length <= 1) return [...base, ...mixes];
    return [...base.take(4), ...mixes];
  }

  static List<DisplayItem> _itemsFromAlbumIds(List<String> ids) => ids
      .map(albumById)
      .whereType<SpotifyAlbum>()
      .map(DisplayItem.fromAlbum)
      .toList();

  static DisplayItem _categoryMixForName(String name, {bool release = false}) {
    final category = searchCategories.firstWhere(
      (c) => c.name == name,
      orElse: () => searchCategories.first,
    );
    final tracks = _trackIdsForCategory(name, release: release);
    final suffix = release ? 'Fresh Finds' : 'Mix';
    final description = release
        ? 'New sounds and fresh picks for $name'
        : 'A handpicked $name set for your mood';

    return DisplayItem(
      id: 'category-${name.toLowerCase().replaceAll(' ', '-')}-${release ? 'fresh' : 'mix'}',
      title: '$name $suffix',
      description: description,
      imageUrl: category.imageUrl,
      color: category.color,
      tracks: tracksForIds(tracks),
    );
  }

  static List<String> _trackIdsForCategory(
    String name, {
    bool release = false,
  }) {
    switch (name) {
      case 'Pop':
        return release
            ? ['8-1', '10-1', '3-3', '6-3']
            : ['3-3', '6-1', '8-2', '10-2', '29-1'];
      case 'Hip-Hop':
        return release
            ? ['35-1', '34-1', '17-1', '13-2']
            : ['2-8', '7-3', '18-12', '20-5', '21-2'];
      case 'R&B':
        return release
            ? ['33-1', '32-1', '4-2']
            : ['1-9', '4-9', '11-2', '32-4', '33-2'];
      case 'Reggaeton':
        return ['5-2', '5-3', '5-4', '5-5', '5-6'];
      case 'Afrobeats':
        return ['30-1', '30-2', '30-3', '30-4', '30-5'];
      case 'French Rap':
        return release
            ? ['28-1', '27-1', '23-1', '31-2']
            : ['24-1', '22-1', '25-1', '31-1', '27-2'];
      case 'Lo-Fi':
        return ['29-1', '29-2', '29-3', '29-4', '29-5'];
      case 'Rock':
        return ['8-3', '9-2', '10-4', '7-5', '16-3'];
      case 'Electronic':
        return ['6-1', '10-1', '1-9', '8-2', '5-4'];
      case 'Jazz':
        return ['11-1', '11-2', '1-4', '4-11', '29-4'];
      case 'Classical':
        return ['3-9', '11-3', '1-4', '4-19', '29-5'];
      case 'K-Pop':
        return ['3-8', '6-2', '8-1', '10-3', '29-6'];
      default:
        return ['1-9', '2-8', '3-3', '4-2', '5-2'];
    }
  }

  static final List<String> _savedAlbumIds = [
    '1',
    '2',
    '4',
    '7',
    '13',
    '18',
    '24',
    '35',
    '34',
    '31',
    '22',
    '16',
  ];

  static List<SpotifyAlbum> get savedAlbums =>
      _savedAlbumIds.map(albumById).whereType<SpotifyAlbum>().toList();

  static const List<Map<String, dynamic>> _rawAlbums = [
    {
      'id': '1',
      'title': 'After Hours',
      'artist': 'The Weeknd',
      'year': '2020',
      'genre': 'R&B',
      'color': '0xFFB71C1C',
      'imageUrl': 'assets/images/spotify albums/The_Weeknd_-_After_Hours.jpg',
      'tracks': [
        {'id': '1-1', 'title': 'Alone Again', 'duration': '4:10'},
        {'id': '1-2', 'title': 'Too Late', 'duration': '3:59'},
        {'id': '1-3', 'title': 'Hardest To Love', 'duration': '3:31'},
        {'id': '1-4', 'title': 'Scared To Live', 'duration': '3:11'},
        {'id': '1-5', 'title': 'Snowchild', 'duration': '4:08'},
        {'id': '1-6', 'title': 'Escape From LA', 'duration': '6:07'},
        {'id': '1-7', 'title': 'Heartless', 'duration': '3:27'},
        {'id': '1-8', 'title': 'Faith', 'duration': '5:04'},
        {'id': '1-9', 'title': 'Blinding Lights', 'duration': '3:20'},
        {'id': '1-10', 'title': 'In Your Eyes', 'duration': '3:57'},
        {'id': '1-11', 'title': 'Save Your Tears', 'duration': '3:36'},
        {'id': '1-12', 'title': 'Repeat After Me', 'duration': '3:37'},
        {'id': '1-13', 'title': 'After Hours', 'duration': '6:01'},
      ],
    },
    {
      'id': '2',
      'title': 'DAMN.',
      'artist': 'Kendrick Lamar',
      'year': '2017',
      'genre': 'Hip-Hop',
      'color': '0xFFB71C1C',
      'imageUrl': 'assets/images/spotify albums/Kendrick_Lamar_-_Damn.png',
      'tracks': [
        {'id': '2-1', 'title': 'BLOOD.', 'duration': '1:59'},
        {'id': '2-2', 'title': 'DNA.', 'duration': '3:05'},
        {'id': '2-3', 'title': 'YAH.', 'duration': '2:39'},
        {'id': '2-4', 'title': 'ELEMENT.', 'duration': '3:27'},
        {'id': '2-5', 'title': 'FEEL.', 'duration': '3:35'},
        {'id': '2-6', 'title': 'LOYALTY.', 'duration': '3:47'},
        {'id': '2-7', 'title': 'PRIDE.', 'duration': '4:31'},
        {'id': '2-8', 'title': 'HUMBLE.', 'duration': '2:57'},
        {'id': '2-9', 'title': 'LUST.', 'duration': '5:07'},
        {'id': '2-10', 'title': 'LOVE.', 'duration': '3:33'},
        {'id': '2-11', 'title': 'XXX.', 'duration': '4:14'},
        {'id': '2-12', 'title': 'FEAR.', 'duration': '7:42'},
        {'id': '2-13', 'title': 'GOD.', 'duration': '4:00'},
        {'id': '2-14', 'title': 'DUCKWORTH.', 'duration': '4:18'},
      ],
    },
    {
      'id': '3',
      'title': 'Midnights',
      'artist': 'Taylor Swift',
      'year': '2022',
      'genre': 'Pop',
      'color': '0xFF1A237E',
      'imageUrl': 'assets/images/spotify albums/Midnights_-_Taylor_Swift.png',
      'tracks': [
        {'id': '3-1', 'title': 'Lavender Haze', 'duration': '3:22'},
        {'id': '3-2', 'title': 'Maroon', 'duration': '3:38'},
        {'id': '3-3', 'title': 'Anti-Hero', 'duration': '3:20'},
        {'id': '3-4', 'title': 'Snow On The Beach', 'duration': '4:16'},
        {'id': '3-5', 'title': 'Midnight Rain', 'duration': '2:54'},
        {'id': '3-6', 'title': 'Question...?', 'duration': '3:47'},
        {'id': '3-7', 'title': 'Vigilante Shit', 'duration': '2:44'},
        {'id': '3-8', 'title': 'Bejeweled', 'duration': '3:14'},
        {'id': '3-9', 'title': 'Labyrinth', 'duration': '4:09'},
        {'id': '3-10', 'title': 'Karma', 'duration': '3:25'},
        {'id': '3-11', 'title': 'Sweet Nothing', 'duration': '3:08'},
        {'id': '3-12', 'title': 'Mastermind', 'duration': '3:12'},
      ],
    },
    {
      'id': '4',
      'title': 'SOS',
      'artist': 'SZA',
      'year': '2022',
      'genre': 'R&B',
      'color': '0xFF006064',
      'imageUrl': 'assets/images/spotify albums/SZA_-_S.O.S.png',
      'tracks': [
        {'id': '4-1', 'title': 'SOS', 'duration': '1:45'},
        {'id': '4-2', 'title': 'Kill Bill', 'duration': '2:33'},
        {'id': '4-3', 'title': 'Seek & Destroy', 'duration': '3:17'},
        {'id': '4-4', 'title': 'Low', 'duration': '2:39'},
        {'id': '4-5', 'title': 'Love Language', 'duration': '2:55'},
        {'id': '4-6', 'title': 'Blind', 'duration': '3:04'},
        {'id': '4-7', 'title': 'Used', 'duration': '2:43'},
        {'id': '4-8', 'title': 'Gone Girl', 'duration': '3:50'},
        {'id': '4-9', 'title': 'Snooze', 'duration': '3:21'},
        {'id': '4-10', 'title': 'Conceited', 'duration': '2:02'},
        {'id': '4-11', 'title': 'Good Days', 'duration': '4:39'},
        {'id': '4-12', 'title': 'Notice Me', 'duration': '2:22'},
        {'id': '4-13', 'title': 'Ghost in the Machine', 'duration': '3:46'},
        {'id': '4-14', 'title': 'Shirt', 'duration': '3:28'},
        {'id': '4-15', 'title': 'Open Arms', 'duration': '3:18'},
        {'id': '4-16', 'title': 'I Hate U', 'duration': '2:39'},
        {'id': '4-17', 'title': 'Far', 'duration': '2:52'},
        {'id': '4-18', 'title': 'Forgiveless', 'duration': '3:19'},
        {'id': '4-19', 'title': 'Nobody Gets Me', 'duration': '2:41'},
        {'id': '4-20', 'title': 'Special', 'duration': '2:53'},
        {'id': '4-21', 'title': 'F2F', 'duration': '2:30'},
        {'id': '4-22', 'title': 'PSA', 'duration': '2:12'},
        {'id': '4-23', 'title': 'Smoking on My Ex Pack', 'duration': '2:10'},
      ],
    },
    {
      'id': '5',
      'title': 'Un Verano Sin Ti',
      'artist': 'Bad Bunny',
      'year': '2022',
      'genre': 'Reggaeton',
      'color': '0xFF1B5E20',
      'imageUrl':
          'assets/images/spotify albums/Bad_Bunny_-_Un_Verano_Sin_Ti.jpg',
      'tracks': [
        {'id': '5-1', 'title': 'El Apagón', 'duration': '10:16'},
        {'id': '5-2', 'title': 'Moscow Mule', 'duration': '4:41'},
        {'id': '5-3', 'title': 'Tití Me Preguntó', 'duration': '4:04'},
        {'id': '5-4', 'title': 'Efecto', 'duration': '3:36'},
        {'id': '5-5', 'title': 'Me Porto Bonito', 'duration': '2:59'},
        {'id': '5-6', 'title': 'Neverita', 'duration': '2:55'},
        {'id': '5-7', 'title': 'Un Coco', 'duration': '2:30'},
        {'id': '5-8', 'title': 'Ojitos Lindos', 'duration': '4:10'},
        {'id': '5-9', 'title': 'Party', 'duration': '3:03'},
        {'id': '5-10', 'title': 'Después de la Playa', 'duration': '2:37'},
      ],
    },
    {
      'id': '6',
      'title': 'Future Nostalgia',
      'artist': 'Dua Lipa',
      'year': '2020',
      'genre': 'Pop',
      'color': '0xFF880E4F',
      'imageUrl':
          'assets/images/spotify albums/Dua_Lipa_-_Future_Nostalgia.jpg',
      'tracks': [
        {'id': '6-1', 'title': 'Future Nostalgia', 'duration': '3:04'},
        {'id': '6-2', 'title': 'Don\'t Start Now', 'duration': '3:28'},
        {'id': '6-3', 'title': 'Cool', 'duration': '3:29'},
        {'id': '6-4', 'title': 'Physical', 'duration': '3:13'},
        {'id': '6-5', 'title': 'Levitating', 'duration': '3:23'},
        {'id': '6-6', 'title': 'Pretty Please', 'duration': '3:23'},
        {'id': '6-7', 'title': 'Hallucinate', 'duration': '3:28'},
        {'id': '6-8', 'title': 'Love Again', 'duration': '4:18'},
        {'id': '6-9', 'title': 'Break My Heart', 'duration': '3:41'},
        {'id': '6-10', 'title': 'Good in Bed', 'duration': '3:38'},
        {'id': '6-11', 'title': 'Boys Will Be Boys', 'duration': '3:01'},
      ],
    },
    {
      'id': '7',
      'title': 'ASTROWORLD',
      'artist': 'Travis Scott',
      'year': '2018',
      'genre': 'Hip-Hop',
      'color': '0xFF4A148C',
      'imageUrl': 'assets/images/spotify albums/Travis_Scott_-_Astroworld.png',
      'tracks': [
        {'id': '7-1', 'title': 'STARGAZING', 'duration': '3:53'},
        {'id': '7-2', 'title': 'CAROUSEL', 'duration': '4:04'},
        {'id': '7-3', 'title': 'SICKO MODE', 'duration': '5:13'},
        {'id': '7-4', 'title': 'R.I.P. SCREW', 'duration': '4:09'},
        {'id': '7-5', 'title': 'STOP TRYING TO BE GOD', 'duration': '5:48'},
        {'id': '7-6', 'title': 'NC-17', 'duration': '3:35'},
        {'id': '7-7', 'title': 'WAKE UP', 'duration': '4:39'},
        {'id': '7-8', 'title': '5% TINT', 'duration': '4:14'},
        {'id': '7-9', 'title': 'HOUSTONFORNICATION', 'duration': '4:27'},
        {'id': '7-10', 'title': 'CAN\'T SAY', 'duration': '3:34'},
        {'id': '7-11', 'title': 'WHO? WHAT!', 'duration': '2:21'},
        {'id': '7-12', 'title': 'YOSEMITE', 'duration': '4:29'},
        {'id': '7-13', 'title': 'COFFEE BEAN', 'duration': '4:17'},
        {'id': '7-14', 'title': 'SKELETONS', 'duration': '3:42'},
        {'id': '7-15', 'title': 'ASTROTHUNDER', 'duration': '3:06'},
        {'id': '7-16', 'title': 'BUTTERFLY EFFECT', 'duration': '3:27'},
        {'id': '7-17', 'title': 'WATCH', 'duration': '3:04'},
      ],
    },
    {
      'id': '8',
      'title': 'Happier Than Ever',
      'artist': 'Billie Eilish',
      'year': '2021',
      'genre': 'Pop',
      'color': '0xFFE0D6CD',
      'imageUrl':
          'assets/images/spotify albums/Billie_Eilish_-_Happier_Than_Ever.jpg',
      'tracks': [
        {'id': '8-1', 'title': 'Getting Older', 'duration': '4:05'},
        {
          'id': '8-2',
          'title': 'I Didn\'t Change My Number',
          'duration': '2:41',
        },
        {'id': '8-3', 'title': 'Billie Bossa Nova', 'duration': '3:16'},
        {'id': '8-4', 'title': 'my future', 'duration': '3:31'},
        {'id': '8-5', 'title': 'Oxytocin', 'duration': '3:38'},
        {'id': '8-6', 'title': 'GOLDWING', 'duration': '2:32'},
        {'id': '8-7', 'title': 'Lost Cause', 'duration': '3:07'},
        {'id': '8-8', 'title': 'Halley\'s Comet', 'duration': '3:52'},
        {'id': '8-9', 'title': 'Not My Responsibility', 'duration': '4:05'},
        {'id': '8-10', 'title': 'OverHeated', 'duration': '3:16'},
        {'id': '8-11', 'title': 'Everybody Dies', 'duration': '3:18'},
        {'id': '8-12', 'title': 'Your Power', 'duration': '4:03'},
        {'id': '8-13', 'title': 'NDA', 'duration': '3:35'},
        {'id': '8-14', 'title': 'Therefore I Am', 'duration': '2:54'},
        {'id': '8-15', 'title': 'Happier Than Ever', 'duration': '4:59'},
        {'id': '8-16', 'title': 'Male Fantasy', 'duration': '3:24'},
      ],
    },
    {
      'id': '9',
      'title': 'Hollywood\'s Bleeding',
      'artist': 'Post Malone',
      'year': '2019',
      'genre': 'Pop-Rap',
      'color': '0xFF37474F',
      'imageUrl':
          'assets/images/spotify albums/Post_Malone_-_Hollywoods_Bleeding.jpg',
      'tracks': [
        {'id': '9-1', 'title': 'Hollywood\'s Bleeding', 'duration': '3:06'},
        {'id': '9-2', 'title': 'Saint-Tropez', 'duration': '2:22'},
        {'id': '9-3', 'title': 'On the Road', 'duration': '2:50'},
        {'id': '9-4', 'title': 'circles', 'duration': '3:35'},
        {'id': '9-5', 'title': 'Enemies', 'duration': '3:15'},
        {'id': '9-6', 'title': 'A Thousand Bad Times', 'duration': '3:06'},
        {'id': '9-7', 'title': 'Sunflower', 'duration': '2:38'},
        {'id': '9-8', 'title': 'Allergic', 'duration': '3:03'},
        {'id': '9-9', 'title': 'Internet', 'duration': '3:04'},
        {'id': '9-10', 'title': 'Staring At The Sun', 'duration': '2:49'},
        {'id': '9-11', 'title': 'Take What You Want', 'duration': '3:38'},
        {'id': '9-12', 'title': 'Wow.', 'duration': '2:25'},
        {'id': '9-13', 'title': 'Cooped Up', 'duration': '2:33'},
        {'id': '9-14', 'title': 'Motley Crew', 'duration': '2:55'},
        {'id': '9-15', 'title': 'I\'m Gonna Be', 'duration': '3:16'},
        {'id': '9-16', 'title': 'Rockstar', 'duration': '3:41'},
        {'id': '9-17', 'title': 'Die For Me', 'duration': '3:45'},
      ],
    },
    {
      'id': '10',
      'title': 'Thank U, Next',
      'artist': 'Ariana Grande',
      'year': '2019',
      'genre': 'Pop',
      'color': '0xFF880E4F',
      'imageUrl':
          'assets/images/spotify albums/Ariana_Grande_-_Thank_U_Next.jpg',
      'tracks': [
        {'id': '10-1', 'title': 'imagine', 'duration': '3:02'},
        {'id': '10-2', 'title': 'needy', 'duration': '2:49'},
        {'id': '10-3', 'title': 'NASA', 'duration': '2:59'},
        {'id': '10-4', 'title': 'bloodline', 'duration': '3:11'},
        {'id': '10-5', 'title': 'fake smile', 'duration': '3:13'},
        {'id': '10-6', 'title': 'bad idea', 'duration': '3:15'},
        {'id': '10-7', 'title': 'make up', 'duration': '2:15'},
        {'id': '10-8', 'title': 'ghostin', 'duration': '3:45'},
        {'id': '10-9', 'title': 'in my head', 'duration': '3:28'},
        {'id': '10-10', 'title': '7 rings', 'duration': '2:58'},
        {'id': '10-11', 'title': 'thank u, next', 'duration': '3:27'},
        {
          'id': '10-12',
          'title': 'break up with your girlfriend, i\'m bored',
          'duration': '3:10',
        },
      ],
    },
    {
      'id': '11',
      'title': 'Blonde',
      'artist': 'Frank Ocean',
      'year': '2016',
      'genre': 'R&B',
      'color': '0xFFF57F17',
      'imageUrl': 'assets/images/spotify albums/Frank_Ocean_-_Blonde.jpg',
      'tracks': [
        {'id': '11-1', 'title': 'Nikes', 'duration': '5:14'},
        {'id': '11-2', 'title': 'Ivy', 'duration': '4:09'},
        {'id': '11-3', 'title': 'Pink + White', 'duration': '3:04'},
        {'id': '11-4', 'title': 'Be Yourself', 'duration': '1:52'},
        {'id': '11-5', 'title': 'Solo', 'duration': '4:23'},
        {'id': '11-6', 'title': 'Skyline To', 'duration': '3:01'},
        {'id': '11-7', 'title': 'Self Control', 'duration': '4:10'},
        {'id': '11-8', 'title': 'Good Guy', 'duration': '1:42'},
        {'id': '11-9', 'title': 'Nights', 'duration': '5:07'},
        {'id': '11-10', 'title': 'Solo (Reprise)', 'duration': '1:00'},
        {'id': '11-11', 'title': 'Pretty Sweet', 'duration': '1:50'},
        {'id': '11-12', 'title': 'Facebook Story', 'duration': '0:58'},
        {'id': '11-13', 'title': 'Close to You', 'duration': '1:12'},
        {'id': '11-14', 'title': 'White Ferrari', 'duration': '4:10'},
        {'id': '11-15', 'title': 'Seigfried', 'duration': '6:03'},
        {'id': '11-16', 'title': 'Godspeed', 'duration': '1:55'},
        {'id': '11-17', 'title': 'Futura Free', 'duration': '9:00'},
      ],
    },
    {
      'id': '12',
      'title': 'The Life of Pablo',
      'artist': 'Kanye West',
      'year': '2016',
      'genre': 'Hip-Hop',
      'color': '0xFF212121',
      'imageUrl':
          'assets/images/spotify albums/Kanye_West_-_The_Life_of_Pablo.jpg',
      'tracks': [
        {'id': '12-1', 'title': 'Ultralight Beam', 'duration': '5:12'},
        {
          'id': '12-2',
          'title': 'Father Stretch My Hands Pt. 1',
          'duration': '2:22',
        },
        {'id': '12-3', 'title': 'Pt. 2', 'duration': '2:24'},
        {'id': '12-4', 'title': 'Famous', 'duration': '3:55'},
        {'id': '12-5', 'title': 'Feedback', 'duration': '2:44'},
        {'id': '12-6', 'title': 'Low Lights', 'duration': '1:44'},
        {'id': '12-7', 'title': 'Highlights', 'duration': '5:17'},
        {'id': '12-8', 'title': 'Freestyle 4', 'duration': '3:25'},
        {'id': '12-9', 'title': 'I Love Kanye', 'duration': '1:01'},
        {'id': '12-10', 'title': 'Waves', 'duration': '3:01'},
        {'id': '12-11', 'title': 'FML', 'duration': '4:28'},
        {'id': '12-12', 'title': 'Real Friends', 'duration': '4:57'},
        {'id': '12-13', 'title': 'Wolves', 'duration': '3:36'},
        {'id': '12-14', 'title': 'Frank\'s Track', 'duration': '0:36'},
        {
          'id': '12-15',
          'title': 'Siiiiiiiiilver Surfffffffffffter Surf',
          'duration': '4:02',
        },
        {'id': '12-16', 'title': '30 Hours', 'duration': '5:00'},
        {'id': '12-17', 'title': 'No More Parties in LA', 'duration': '6:31'},
        {
          'id': '12-18',
          'title': 'Facts (Charlie Heat Version)',
          'duration': '3:29',
        },
        {'id': '12-19', 'title': 'Fade', 'duration': '4:20'},
      ],
    },
    {
      'id': '13',
      'title': '23',
      'artist': 'Central Cee',
      'year': '2022',
      'genre': 'Hip-Hop',
      'color': '0xFF212121',
      'imageUrl': 'assets/images/spotify albums/central cee 23.jpg',
      'tracks': [
        {'id': '13-1', 'title': 'Loading', 'duration': '2:10'},
        {'id': '13-2', 'title': 'Retail Therapy', 'duration': '2:45'},
        {'id': '13-3', 'title': 'Obsessed With You', 'duration': '2:30'},
        {'id': '13-4', 'title': 'Doja', 'duration': '2:15'},
        {'id': '13-5', 'title': 'Six of Swords', 'duration': '3:00'},
      ],
    },
    {
      'id': '14',
      'title': 'Can\'t Rush Greatness',
      'artist': 'Central Cee',
      'year': '2022',
      'genre': 'Hip-Hop',
      'color': '0xFF37474F',
      'imageUrl': 'assets/images/spotify albums/central cee crg.jpg',
      'tracks': [
        {'id': '14-1', 'title': 'Day in the Life', 'duration': '2:50'},
        {'id': '14-2', 'title': 'Commitment Issues', 'duration': '2:38'},
        {'id': '14-3', 'title': 'Gyaldem', 'duration': '2:22'},
        {'id': '14-4', 'title': 'Pinging', 'duration': '2:45'},
        {'id': '14-5', 'title': 'Sprinter', 'duration': '3:05'},
      ],
    },
    {
      'id': '15',
      'title': 'Wild West',
      'artist': 'Central Cee',
      'year': '2021',
      'genre': 'Hip-Hop',
      'color': '0xFF4A148C',
      'imageUrl': 'assets/images/spotify albums/central cee wild west.jpg',
      'tracks': [
        {'id': '15-1', 'title': 'Trap Back', 'duration': '2:30'},
        {'id': '15-2', 'title': 'Molly', 'duration': '2:15'},
        {'id': '15-3', 'title': 'Weekend', 'duration': '2:50'},
        {'id': '15-4', 'title': 'Fade Away', 'duration': '2:40'},
        {'id': '15-5', 'title': 'Cold Shoulder', 'duration': '2:55'},
      ],
    },
    {
      'id': '16',
      'title': 'We\'re All Alone in This Together',
      'artist': 'Dave',
      'year': '2021',
      'genre': 'Hip-Hop',
      'color': '0xFF1A237E',
      'imageUrl':
          'assets/images/spotify albums/Dave_-_We\'re_All_Alone_in_This_Together.jpg',
      'tracks': [
        {'id': '16-1', 'title': 'Clash', 'duration': '4:10'},
        {'id': '16-2', 'title': 'In the Fire', 'duration': '5:20'},
        {'id': '16-3', 'title': 'Lazarus', 'duration': '3:50'},
        {'id': '16-4', 'title': 'Verdance', 'duration': '4:30'},
        {'id': '16-5', 'title': 'System', 'duration': '5:00'},
        {'id': '16-6', 'title': 'Survivor\'s Guilt', 'duration': '4:45'},
      ],
    },
    {
      'id': '17',
      'title': 'Split Decision',
      'artist': 'Dave & Central Cee',
      'year': '2023',
      'genre': 'Hip-Hop',
      'color': '0xFF006064',
      'imageUrl':
          'assets/images/spotify albums/Dave_and_Central_Cee_-_Sprinter.png',
      'tracks': [
        {'id': '17-1', 'title': 'Trojan Horse', 'duration': '3:06'},
        {'id': '17-2', 'title': 'Sprinter', 'duration': '3:05'},
        {'id': '17-3', 'title': 'Our 25th Birthday', 'duration': '3:14'},
        {'id': '17-4', 'title': 'UK Rap', 'duration': '2:48'},
      ],
    },
    {
      'id': '18',
      'title': 'Views',
      'artist': 'Drake',
      'year': '2016',
      'genre': 'Hip-Hop',
      'color': '0xFF37474F',
      'imageUrl': 'assets/images/spotify albums/Drake_-_Views_cover.jpg',
      'tracks': [
        {'id': '18-1', 'title': 'Keep the Family Close', 'duration': '4:58'},
        {'id': '18-2', 'title': '9', 'duration': '4:31'},
        {'id': '18-3', 'title': 'U With Me?', 'duration': '4:10'},
        {'id': '18-4', 'title': 'Feel No Ways', 'duration': '3:44'},
        {'id': '18-5', 'title': 'Hype', 'duration': '3:24'},
        {'id': '18-6', 'title': 'Weston Road Flows', 'duration': '5:35'},
        {'id': '18-7', 'title': 'Redemption', 'duration': '4:48'},
        {'id': '18-8', 'title': 'With You', 'duration': '3:52'},
        {'id': '18-9', 'title': 'Faithful', 'duration': '4:53'},
        {'id': '18-10', 'title': 'Still Here', 'duration': '4:25'},
        {'id': '18-11', 'title': 'Controlla', 'duration': '3:43'},
        {'id': '18-12', 'title': 'One Dance', 'duration': '2:54'},
        {'id': '18-13', 'title': 'Grammys', 'duration': '4:05'},
        {'id': '18-14', 'title': 'Child\'s Play', 'duration': '3:39'},
        {'id': '18-15', 'title': 'Pop Style', 'duration': '3:12'},
        {'id': '18-16', 'title': 'Too Good', 'duration': '4:10'},
        {'id': '18-17', 'title': 'Summers Over Interlude', 'duration': '2:02'},
        {'id': '18-18', 'title': 'Fire & Desire', 'duration': '5:04'},
        {'id': '18-19', 'title': 'Views', 'duration': '3:36'},
        {'id': '18-20', 'title': 'Hotline Bling', 'duration': '4:27'},
      ],
    },
    {
      'id': '19',
      'title': 'Scorpion',
      'artist': 'Drake',
      'year': '2018',
      'genre': 'Hip-Hop',
      'color': '0xFF212121',
      'imageUrl': 'assets/images/spotify albums/Scorpion_by_Drake.jpg',
      'tracks': [
        {'id': '19-1', 'title': 'Survival', 'duration': '3:28'},
        {'id': '19-2', 'title': 'Nonstop', 'duration': '3:39'},
        {'id': '19-3', 'title': 'Elevate', 'duration': '3:14'},
        {'id': '19-4', 'title': 'Emotionless', 'duration': '4:48'},
        {'id': '19-5', 'title': 'God\'s Plan', 'duration': '3:19'},
        {'id': '19-6', 'title': 'I\'m Upset', 'duration': '3:08'},
        {'id': '19-7', 'title': '8 Out of 10', 'duration': '3:59'},
        {'id': '19-8', 'title': 'Talk Up', 'duration': '2:56'},
        {'id': '19-9', 'title': 'Is There More', 'duration': '4:48'},
        {'id': '19-10', 'title': 'Peak', 'duration': '3:32'},
        {'id': '19-11', 'title': 'Summer Games', 'duration': '3:20'},
        {'id': '19-12', 'title': 'Jaded', 'duration': '3:10'},
        {'id': '19-13', 'title': 'Nice for What', 'duration': '3:30'},
        {'id': '19-14', 'title': 'Finesse', 'duration': '3:37'},
        {'id': '19-15', 'title': 'Ratchet Happy Birthday', 'duration': '1:07'},
        {'id': '19-16', 'title': 'That\'s How You Feel', 'duration': '2:59'},
        {'id': '19-17', 'title': 'Blue Tint', 'duration': '4:18'},
        {'id': '19-18', 'title': 'In My Feelings', 'duration': '3:37'},
        {'id': '19-19', 'title': 'Don\'t Matter to Me', 'duration': '3:48'},
        {'id': '19-20', 'title': 'After Dark', 'duration': '4:46'},
        {'id': '19-21', 'title': 'Final Fantasy', 'duration': '3:25'},
        {'id': '19-22', 'title': 'March 14', 'duration': '5:09'},
      ],
    },
    {
      'id': '20',
      'title': 'KOD',
      'artist': 'J. Cole',
      'year': '2018',
      'genre': 'Hip-Hop',
      'color': '0xFF4A148C',
      'imageUrl': 'assets/images/spotify albums/jcole kod.jpg',
      'tracks': [
        {'id': '20-1', 'title': 'Intro', 'duration': '1:35'},
        {'id': '20-2', 'title': 'KOD', 'duration': '3:48'},
        {'id': '20-3', 'title': 'Photograph', 'duration': '4:00'},
        {'id': '20-4', 'title': 'The Cut Off', 'duration': '3:31'},
        {'id': '20-5', 'title': 'ATM', 'duration': '3:24'},
        {'id': '20-6', 'title': 'Motiv8', 'duration': '1:42'},
        {'id': '20-7', 'title': 'Kevin\'s Heart', 'duration': '3:31'},
        {'id': '20-8', 'title': 'Window Pain', 'duration': '4:37'},
        {'id': '20-9', 'title': 'FRIENDS', 'duration': '5:29'},
        {'id': '20-10', 'title': 'Once an Addict', 'duration': '5:25'},
        {'id': '20-11', 'title': '1985', 'duration': '5:06'},
      ],
    },
    {
      'id': '21',
      'title': 'The Forever Story',
      'artist': 'JID',
      'year': '2022',
      'genre': 'Hip-Hop',
      'color': '0xFF1B5E20',
      'imageUrl': 'assets/images/spotify albums/jid the forever tree.jpg',
      'tracks': [
        {'id': '21-1', 'title': 'Galaxy', 'duration': '2:55'},
        {'id': '21-2', 'title': 'Surround Sound', 'duration': '4:18'},
        {'id': '21-3', 'title': 'Can\'t Punk Me', 'duration': '2:50'},
        {'id': '21-4', 'title': 'Dance Now', 'duration': '3:15'},
        {'id': '21-5', 'title': 'Kody Blu 31', 'duration': '3:46'},
        {'id': '21-6', 'title': 'Better Days', 'duration': '4:10'},
        {'id': '21-7', 'title': 'Bruddanem', 'duration': '3:22'},
        {'id': '21-8', 'title': 'Raydar', 'duration': '3:05'},
        {'id': '21-9', 'title': '2007', 'duration': '4:30'},
        {'id': '21-10', 'title': 'Sistanem', 'duration': '2:48'},
        {'id': '21-11', 'title': 'Lauder', 'duration': '3:35'},
        {'id': '21-12', 'title': 'Crack Sandwich', 'duration': '3:55'},
        {'id': '21-13', 'title': 'Money', 'duration': '3:10'},
        {'id': '21-14', 'title': 'Sa Roc', 'duration': '3:42'},
        {'id': '21-15', 'title': 'Stars', 'duration': '4:05'},
      ],
    },
    {
      'id': '22',
      'title': 'J.O.S.',
      'artist': 'Josman',
      'year': '2020',
      'genre': 'Hip-Hop',
      'color': '0xFF880E4F',
      'imageUrl': r'assets/images/spotify albums/Josman - J.O.$.jpg',
      'tracks': [
        {'id': '22-1', 'title': 'Intro', 'duration': '2:06'},
        {'id': '22-2', 'title': 'J.O.S.', 'duration': '3:09'},
        {'id': '22-3', 'title': 'Matrix', 'duration': '3:08'},
        {'id': '22-4', 'title': 'Dans le vide', 'duration': '3:43'},
        {'id': '22-5', 'title': 'Lonely', 'duration': '3:20'},
        {'id': '22-6', 'title': 'High', 'duration': '3:18'},
        {'id': '22-7', 'title': 'Comme eux', 'duration': '3:32'},
        {'id': '22-8', 'title': 'Poto', 'duration': '3:06'},
        {'id': '22-9', 'title': 'V&V', 'duration': '3:15'},
        {'id': '22-10', 'title': 'No Name', 'duration': '3:27'},
        {'id': '22-11', 'title': 'Coffre plein', 'duration': '3:11'},
        {'id': '22-12', 'title': 'Encore', 'duration': '3:41'},
        {'id': '22-13', 'title': 'Monde à part', 'duration': '3:54'},
      ],
    },
    {
      'id': '23',
      'title': 'Split',
      'artist': 'Josman',
      'year': '2020',
      'genre': 'Hip-Hop',
      'color': '0xFF006064',
      'imageUrl': 'assets/images/spotify albums/Josman - split.jpg',
      'tracks': [
        {'id': '23-1', 'title': 'Larmes de Sel (Intro)', 'duration': '1:39'},
        {'id': '23-2', 'title': 'Petite Bulle', 'duration': '3:41'},
        {'id': '23-3', 'title': 'J\'allume', 'duration': '3:24'},
        {'id': '23-4', 'title': 'Factice', 'duration': '3:31'},
        {'id': '23-5', 'title': 'Si tu savais...', 'duration': '4:11'},
        {'id': '23-6', 'title': 'Seul', 'duration': '2:57'},
        {'id': '23-7', 'title': 'Mauvaise Humeur', 'duration': '2:37'},
        {'id': '23-8', 'title': 'Bambi', 'duration': '3:53'},
        {'id': '23-9', 'title': 'Feu.Bi', 'duration': '2:51'},
        {'id': '23-10', 'title': 'Argent, Drogue & Sexe', 'duration': '3:15'},
        {'id': '23-11', 'title': 'Bruce Wayne', 'duration': '3:12'},
        {'id': '23-12', 'title': 'Lifestyle', 'duration': '2:55'},
        {'id': '23-13', 'title': 'Fleur d\'Amour', 'duration': '1:42'},
        {'id': '23-14', 'title': 'Bon.Char', 'duration': '3:25'},
        {'id': '23-15', 'title': 'Mallette', 'duration': '3:33'},
        {'id': '23-16', 'title': 'B!tch', 'duration': '3:08'},
        {'id': '23-17', 'title': 'Illégale', 'duration': '3:06'},
        {'id': '23-18', 'title': 'Dégaine', 'duration': '3:51'},
        {'id': '23-19', 'title': 'BAG (Skit)', 'duration': '1:18'},
        {'id': '23-20', 'title': 'Je Sais', 'duration': '2:37'},
        {'id': '23-21', 'title': 'À Notre Âge', 'duration': '3:07'},
        {'id': '23-22', 'title': 'BabyGirl', 'duration': '3:45'},
        {'id': '23-23', 'title': 'STOP! (Outro)', 'duration': '3:30'},
      ],
    },
    {
      'id': '24',
      'title': 'Cyborg',
      'artist': 'Nekfeu',
      'year': '2016',
      'genre': 'Hip-Hop',
      'color': '0xFF212121',
      'imageUrl': 'assets/images/spotify albums/nekfeu cyborg.jpg',
      'tracks': [
        {'id': '24-1', 'title': 'Humanoïde', 'duration': '3:49'},
        {'id': '24-2', 'title': 'Squa', 'duration': '3:23'},
        {'id': '24-3', 'title': 'Mauvaise graine', 'duration': '3:41'},
        {'id': '24-4', 'title': 'Esquimaux', 'duration': '4:03'},
        {'id': '24-5', 'title': 'Besoin de sens', 'duration': '3:56'},
        {'id': '24-6', 'title': 'Avant tu riais', 'duration': '3:28'},
        {'id': '24-7', 'title': 'Galatée', 'duration': '4:07'},
        {'id': '24-8', 'title': 'O.D', 'duration': '3:15'},
        {'id': '24-9', 'title': 'Rêve d\'avoir des rêves', 'duration': '4:12'},
        {'id': '24-10', 'title': 'Saturne', 'duration': '4:01'},
        {'id': '24-11', 'title': 'Nekketsu', 'duration': '3:34'},
        {'id': '24-12', 'title': 'Takotsubo', 'duration': '3:52'},
        {'id': '24-13', 'title': 'Princesse', 'duration': '3:39'},
        {'id': '24-14', 'title': 'Égérie', 'duration': '3:46'},
        {'id': '24-15', 'title': 'Programmé', 'duration': '3:58'},
        {'id': '24-16', 'title': 'Le bruit qui court', 'duration': '4:05'},
        {'id': '24-17', 'title': 'Plume', 'duration': '3:50'},
      ],
    },
    {
      'id': '25',
      'title': 'Les étoiles vagabondes',
      'artist': 'Nekfeu',
      'year': '2019',
      'genre': 'Hip-Hop',
      'color': '0xFF1A237E',
      'imageUrl': 'assets/images/spotify albums/nekfeu etoiles vagabondes.jpg',
      'tracks': [
        {'id': '25-1', 'title': 'Étoiles vagabondes', 'duration': '2:44'},
        {'id': '25-2', 'title': 'Cheum', 'duration': '3:16'},
        {'id': '25-3', 'title': 'Natsukashii', 'duration': '3:58'},
        {'id': '25-4', 'title': 'Ciel noir', 'duration': '3:49'},
        {'id': '25-5', 'title': 'De mon mieux', 'duration': '4:05'},
        {'id': '25-6', 'title': 'Tricheur', 'duration': '3:39'},
        {'id': '25-7', 'title': 'Dans l\'univers', 'duration': '3:34'},
        {'id': '25-8', 'title': 'Premier pas', 'duration': '3:21'},
        {'id': '25-9', 'title': 'Koala mouillé', 'duration': '3:13'},
        {'id': '25-10', 'title': 'Takotsubo', 'duration': '3:50'},
        {'id': '25-11', 'title': 'Nuit en apesanteur', 'duration': '3:27'},
        {'id': '25-12', 'title': 'Compte les hommes', 'duration': '3:41'},
        {'id': '25-13', 'title': 'Ciel noir (Outro)', 'duration': '3:02'},
      ],
    },
    {
      'id': '26',
      'title': 'Feu',
      'artist': 'Nekfeu',
      'year': '2015',
      'genre': 'Hip-Hop',
      'color': '0xFFB71C1C',
      'imageUrl': 'assets/images/spotify albums/nekfeu feu.jpg',
      'tracks': [
        {'id': '26-1', 'title': 'Nique les clones, Pt. II', 'duration': '3:52'},
        {'id': '26-2', 'title': 'On verra', 'duration': '3:19'},
        {'id': '26-3', 'title': 'Égérie', 'duration': '3:58'},
        {'id': '26-4', 'title': 'Princesse', 'duration': '3:45'},
        {'id': '26-5', 'title': 'Tempête', 'duration': '3:36'},
        {'id': '26-6', 'title': 'Mon âme', 'duration': '3:29'},
        {'id': '26-7', 'title': 'Rêve d\'avoir des rêves', 'duration': '3:50'},
        {'id': '26-8', 'title': 'Question d\'honneur', 'duration': '3:18'},
        {'id': '26-9', 'title': 'Je sais pas danser', 'duration': '3:22'},
        {'id': '26-10', 'title': 'Reuf', 'duration': '3:27'},
        {'id': '26-11', 'title': 'Martin Eden', 'duration': '4:05'},
        {'id': '26-12', 'title': 'Plume', 'duration': '3:48'},
        {'id': '26-13', 'title': 'Time B.O.M.B.', 'duration': '4:12'},
        {'id': '26-14', 'title': 'Le bruit qui court', 'duration': '3:40'},
        {'id': '26-15', 'title': 'Nostalgie', 'duration': '3:30'},
        {'id': '26-16', 'title': 'Outro', 'duration': '2:50'},
      ],
    },
    {
      'id': '27',
      'title': 'Le monde est méchant',
      'artist': 'Niska',
      'year': '2018',
      'genre': 'Hip-Hop',
      'color': '0xFF4A148C',
      'imageUrl':
          'assets/images/spotify albums/niska le monde est mechant v2.jpg',
      'tracks': [
        {'id': '27-1', 'title': 'Méchant', 'duration': '3:06'},
        {'id': '27-2', 'title': 'Salé', 'duration': '3:09'},
        {'id': '27-3', 'title': 'Chasse à l\'homme', 'duration': '3:21'},
        {'id': '27-4', 'title': 'Médicament', 'duration': '3:17'},
        {'id': '27-5', 'title': 'Amour X', 'duration': '3:28'},
        {'id': '27-6', 'title': 'Réseaux', 'duration': '2:48'},
        {'id': '27-7', 'title': 'La wewer', 'duration': '3:05'},
        {'id': '27-8', 'title': 'Freestyle PSG', 'duration': '2:58'},
        {'id': '27-9', 'title': 'Tuba Life', 'duration': '3:12'},
        {'id': '27-10', 'title': 'Goutte d\'eau', 'duration': '3:25'},
        {'id': '27-11', 'title': 'Commission', 'duration': '3:08'},
        {'id': '27-12', 'title': 'Versus', 'duration': '3:14'},
        {'id': '27-13', 'title': 'Outro', 'duration': '2:40'},
      ],
    },
    {
      'id': '28',
      'title': 'Mr Sal',
      'artist': 'Niska',
      'year': '2019',
      'genre': 'Hip-Hop',
      'color': '0xFF1B5E20',
      'imageUrl': 'assets/images/spotify albums/niska mr sal.jpg',
      'tracks': [
        {'id': '28-1', 'title': 'Méchant', 'duration': '3:05'},
        {'id': '28-2', 'title': 'Du lundi au lundi', 'duration': '3:08'},
        {'id': '28-3', 'title': 'Maman ne le sait pas', 'duration': '3:15'},
        {'id': '28-4', 'title': 'Bâtiment', 'duration': '3:02'},
        {'id': '28-5', 'title': 'Siliconé', 'duration': '3:11'},
        {'id': '28-6', 'title': 'Sal', 'duration': '3:07'},
        {'id': '28-7', 'title': 'Médicament', 'duration': '3:10'},
        {'id': '28-8', 'title': 'Valise', 'duration': '3:18'},
        {'id': '28-9', 'title': 'La zone est minée', 'duration': '3:22'},
        {'id': '28-10', 'title': 'Glock', 'duration': '3:06'},
        {'id': '28-11', 'title': 'Criminel', 'duration': '3:20'},
        {'id': '28-12', 'title': 'Outro', 'duration': '2:45'},
      ],
    },
    {
      'id': '29',
      'title': 'Poems of the Past',
      'artist': 'Powfu',
      'year': '2020',
      'genre': 'Pop',
      'color': '0xFF37474F',
      'imageUrl': 'assets/images/spotify albums/powfu poems of the past.jpg',
      'tracks': [
        {
          'id': '29-1',
          'title': 'death bed (coffee for your head)',
          'duration': '2:53',
        },
        {'id': '29-2', 'title': 'i could never be loved', 'duration': '2:56'},
        {
          'id': '29-3',
          'title': 'i don\'t wanna fall in love',
          'duration': '2:45',
        },
        {
          'id': '29-4',
          'title': 'you were the song I was singing',
          'duration': '2:30',
        },
        {'id': '29-5', 'title': 'go back', 'duration': '2:20'},
        {'id': '29-6', 'title': 'summer nights', 'duration': '2:55'},
        {'id': '29-7', 'title': 'would look perfect', 'duration': '2:41'},
      ],
    },
    {
      'id': '30',
      'title': 'Outside',
      'artist': 'Burna Boy',
      'year': '2018',
      'genre': 'Afrobeats',
      'color': '0xFF1B5E20',
      'imageUrl': 'assets/images/spotify albums/burna boy outside.jpg',
      'tracks': [
        {'id': '30-1', 'title': 'Heaven\'s Gate', 'duration': '4:05'},
        {'id': '30-2', 'title': 'Ye', 'duration': '3:28'},
        {'id': '30-3', 'title': 'Gbona', 'duration': '3:15'},
        {'id': '30-4', 'title': 'Karma', 'duration': '3:40'},
        {'id': '30-5', 'title': 'Outside', 'duration': '3:55'},
        {'id': '30-6', 'title': 'Gbona', 'duration': '3:10'},
        {'id': '30-7', 'title': 'Koni Baje', 'duration': '3:30'},
        {'id': '30-8', 'title': 'Sekkle Down', 'duration': '3:20'},
      ],
    },
    {
      'id': '31',
      'title': 'Lithopédion',
      'artist': 'Damso',
      'year': '2017',
      'genre': 'Hip-Hop',
      'color': '0xFF212121',
      'imageUrl': 'assets/images/spotify albums/damso lithopedion.jpg',
      'tracks': [
        {'id': '31-1', 'title': 'Black Mirror', 'duration': '3:14'},
        {'id': '31-2', 'title': 'Smog', 'duration': '3:35'},
        {'id': '31-3', 'title': 'Amnésie', 'duration': '3:49'},
        {'id': '31-4', 'title': 'Une âme pour deux', 'duration': '3:32'},
        {'id': '31-5', 'title': 'Julien', 'duration': '3:21'},
        {'id': '31-6', 'title': 'Démons', 'duration': '3:58'},
        {'id': '31-7', 'title': 'Silence', 'duration': '3:27'},
        {'id': '31-8', 'title': 'Humains', 'duration': '3:40'},
        {'id': '31-9', 'title': 'Mosaïque solitaire', 'duration': '4:03'},
        {'id': '31-10', 'title': 'N. J Respect R', 'duration': '3:18'},
        {'id': '31-11', 'title': 'Dieu ne ment jamais', 'duration': '3:44'},
        {'id': '31-12', 'title': 'K. K. T', 'duration': '3:36'},
        {'id': '31-13', 'title': 'Batterie faible', 'duration': '3:11'},
        {'id': '31-14', 'title': 'Kin la belle', 'duration': '3:29'},
      ],
    },
    {
      'id': '32',
      'title': 'Poison ou Antidote',
      'artist': 'Dadju',
      'year': '2019',
      'genre': 'R&B',
      'color': '0xFF880E4F',
      'imageUrl': 'assets/images/spotify albums/dadju poison ou antidote.jpg',
      'tracks': [
        {'id': '32-1', 'title': 'Antidote', 'duration': '3:15'},
        {'id': '32-2', 'title': 'Poison', 'duration': '3:08'},
        {'id': '32-3', 'title': 'Compliqué', 'duration': '3:27'},
        {'id': '32-4', 'title': 'Mon soleil', 'duration': '3:21'},
        {'id': '32-5', 'title': 'Ma vie', 'duration': '3:30'},
        {'id': '32-6', 'title': 'Nous', 'duration': '3:40'},
        {'id': '32-7', 'title': 'Confessions', 'duration': '3:18'},
        {'id': '32-8', 'title': 'J\'ai dit non', 'duration': '3:22'},
        {'id': '32-9', 'title': 'Comme toi', 'duration': '3:35'},
        {'id': '32-10', 'title': 'Danger', 'duration': '3:12'},
      ],
    },
    {
      'id': '33',
      'title': 'Héritage',
      'artist': 'Dadju',
      'year': '2020',
      'genre': 'R&B',
      'color': '0xFF1A237E',
      'imageUrl': 'assets/images/spotify albums/dadju heritage.jpg',
      'tracks': [
        {'id': '33-1', 'title': 'Dieu merci', 'duration': '3:12'},
        {'id': '33-2', 'title': 'Va dire à ton ex', 'duration': '3:20'},
        {'id': '33-3', 'title': 'Je ne t\'aime plus', 'duration': '3:18'},
        {'id': '33-4', 'title': 'Téléphone', 'duration': '3:25'},
        {'id': '33-5', 'title': 'Par amour', 'duration': '3:30'},
        {'id': '33-6', 'title': 'Bébé', 'duration': '3:10'},
        {'id': '33-7', 'title': 'Jaloux 2', 'duration': '3:22'},
        {'id': '33-8', 'title': 'Amour toxic', 'duration': '3:35'},
      ],
    },
    {
      'id': '34',
      'title': 'Boys Club Vol. 1',
      'artist': 'Beri Boys',
      'year': '2025',
      'genre': 'Hip-Hop',
      'color': '0xFF0C1E1E',
      'imageUrl': 'assets/images/spotify albums/beri boys clu vol1.jpg',
      'tracks': [
        {'id': '34-1', 'title': 'Nous deux (feat. Bvfy)', 'duration': '4:27'},
        {'id': '34-2', 'title': 'On fonctionne', 'duration': '2:53'},
        {'id': '34-3', 'title': '10 (feat. Slkrack)', 'duration': '4:01'},
        {'id': '34-4', 'title': 'Sors ça', 'duration': '3:02'},
        {
          'id': '34-5',
          'title': 'On nous connait (feat. Khafardo & LJR)',
          'duration': '3:32',
        },
        {'id': '34-6', 'title': 'Édubé', 'duration': '3:33'},
        {'id': '34-7', 'title': 'Canada', 'duration': '2:55'},
        {'id': '34-8', 'title': 'Kado', 'duration': '3:00'},
        {'id': '34-9', 'title': 'Waka Waka', 'duration': '2:57'},
        {'id': '34-10', 'title': 'Té Té Ri Té', 'duration': '2:45'},
        {'id': '34-11', 'title': 'Sokoto', 'duration': '3:33'},
      ],
    },
    {
      'id': '35',
      'title': 'Beri to the World',
      'artist': 'Beri Boys',
      'year': '2026',
      'genre': 'Hip-Hop',
      'color': '0xFFCBA068',
      'imageUrl': 'assets/images/spotify albums/Beri To The World.jpg',
      'tracks': [
        {'id': '35-1', 'title': 'God Bless', 'duration': '3:06'},
        {'id': '35-2', 'title': 'Sans Soucis', 'duration': '2:43'},
        {
          'id': '35-3',
          'title': 'Mbalè (feat. Charlotte Mbango)',
          'duration': '3:00',
        },
        {'id': '35-4', 'title': "Je t'avais dit", 'duration': '3:12'},
        {'id': '35-5', 'title': 'Mariage', 'duration': '3:15'},
        {'id': '35-6', 'title': 'Donne moi le temps', 'duration': '2:59'},
        {
          'id': '35-7',
          'title': 'Game Over (feat. Trois Officiel)',
          'duration': '3:30',
        },
        {'id': '35-8', 'title': 'Peux Pas (feat. Ludovic)', 'duration': '3:12'},
        {'id': '35-9', 'title': 'Multiplier', 'duration': '2:44'},
        {'id': '35-10', 'title': 'Stay (feat. Phido)', 'duration': '3:48'},
        {'id': '35-11', 'title': 'Call Me', 'duration': '3:06'},
        {'id': '35-12', 'title': 'CQSP', 'duration': '3:14'},
      ],
    },
  ];

  static const List<Map<String, dynamic>> _rawArtists = [
    {
      'id': 'a-1',
      'name': 'The Weeknd',
      'imageUrl': 'assets/images/spotify artist/the weeknd.jpg',
      'albumIds': ['1'],
      'genres': ['R&B', 'Pop'],
    },
    {
      'id': 'a-2',
      'name': 'Kendrick Lamar',
      'imageUrl': 'assets/images/spotify artist/kendrick lamar.jpg',
      'albumIds': ['2'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-3',
      'name': 'Taylor Swift',
      'imageUrl': 'assets/images/spotify artist/taylor swift.jpg',
      'albumIds': ['3'],
      'genres': ['Pop'],
    },
    {
      'id': 'a-4',
      'name': 'SZA',
      'imageUrl': 'assets/images/spotify artist/sza.jpg',
      'albumIds': ['4'],
      'genres': ['R&B'],
    },
    {
      'id': 'a-5',
      'name': 'Travis Scott',
      'imageUrl': 'assets/images/spotify artist/travis scott.jpg',
      'albumIds': ['7'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-6',
      'name': 'Drake',
      'imageUrl': 'assets/images/spotify artist/drake.jpg',
      'albumIds': ['18', '19'],
      'genres': ['Hip-Hop', 'R&B'],
    },
    {
      'id': 'a-7',
      'name': 'Central Cee',
      'imageUrl': 'assets/images/spotify artist/central cee.jpg',
      'albumIds': ['13', '14', '15'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-8',
      'name': 'Dave',
      'imageUrl': 'assets/images/spotify artist/dave.jpg',
      'albumIds': ['16'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-9',
      'name': 'J. Cole',
      'imageUrl': 'assets/images/spotify artist/jcole.jpg',
      'albumIds': ['20'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-10',
      'name': 'JID',
      'imageUrl': 'assets/images/spotify artist/JID.jpg',
      'albumIds': ['21'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-11',
      'name': 'Josman',
      'imageUrl': 'assets/images/spotify artist/josman.jpg',
      'albumIds': ['22', '23'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-12',
      'name': 'Nekfeu',
      'imageUrl': 'assets/images/spotify artist/nekfeu.jpg',
      'albumIds': ['24', '25', '26'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-13',
      'name': 'Niska',
      'imageUrl': 'assets/images/spotify artist/niska.jpg',
      'albumIds': ['27', '28'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-14',
      'name': 'Powfu',
      'imageUrl': 'assets/images/spotify artist/powfu.png',
      'albumIds': ['29'],
      'genres': ['Pop', 'Lo-Fi'],
    },
    {
      'id': 'a-15',
      'name': 'Burna Boy',
      'imageUrl': 'assets/images/spotify artist/burna boy.jpg',
      'albumIds': ['30'],
      'genres': ['Afrobeats'],
    },
    {
      'id': 'a-16',
      'name': 'Damso',
      'imageUrl': 'assets/images/spotify artist/damso.jpg',
      'albumIds': ['31'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-17',
      'name': 'Dadju',
      'imageUrl': 'assets/images/spotify artist/dadju.jpg',
      'albumIds': ['32', '33'],
      'genres': ['R&B'],
    },
    {
      'id': 'a-18',
      'name': 'Beri Boys',
      'imageUrl': 'assets/images/spotify artist/beri boys.jpg',
      'albumIds': ['34', '35'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-19',
      'name': 'Bramsito',
      'imageUrl': 'assets/images/spotify artist/bramsito.jpg',
      'albumIds': ['36'],
      'genres': ['Hip-Hop'],
    },
    {
      'id': 'a-20',
      'name': 'Didi B',
      'imageUrl': 'assets/images/spotify artist/didi b.jpg',
      'albumIds': ['37'],
      'genres': ['Hip-Hop'],
    },
  ];
}
