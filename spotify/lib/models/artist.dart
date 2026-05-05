class SpotifyArtist {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> albumIds;
  final List<String> genres;

  const SpotifyArtist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.albumIds,
    required this.genres,
  });
}