import 'package:spotify/domain/entities/song/song.dart';

// File: artist_entity.dart
class ArtistEntity {
  final String artistId;
  final String name;
  final String? bio;
  final String? imageUrl;
  final List<SongEntity> songs;

  ArtistEntity({
    required this.artistId,
    required this.name,
    this.bio,
    this.imageUrl,
    required this.songs,
  });
}
