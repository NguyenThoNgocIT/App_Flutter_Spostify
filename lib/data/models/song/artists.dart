import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/artist.dart';
class ArtistModel {
  String? artistId;
  String? name;
  String? bio;
  String? imageUrl;
  List<SongModel>? songs;

  ArtistModel({
    required this.artistId,
    required this.name,
    this.bio,
    this.imageUrl,
    this.songs,
  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    artistId = data['id']?.toString();
    name = data['name'];
    bio = data['bio'];
    imageUrl = data['imageUrl'];
    if (data['song_artists'] != null && data['song_artists'] is List) {
      songs = (data['song_artists'] as List)
          .map((songArtist) {
            final songData = songArtist['song'] as Map<String, dynamic>? ?? {};
            return SongModel.fromJson(songData);
          })
          .toList();
    } else {
      songs = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'name': name,
      'bio': bio,
      'imageUrl': imageUrl,
      'songs': songs?.map((song) => {
            'title': song.title,
            'artist': song.artist,
            'duration': song.duration,
            'releasedate': song.releasedate?.toIso8601String(),
            'isfavorite': song.isfavorite,
            'songid': song.songid,
            'audioUrl': song.audioUrl,
            'filename': song.filename,
            'coverfilename': song.coverfilename,
          }).toList() ?? [],
    };
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      artistId: artistId ?? "Unknown Artist ID",
      name: name ?? "Unknown Artist",
      bio: bio,
      imageUrl: imageUrl,
      songs: songs?.map((song) => song.toEntity()).toList() ?? [],
    );
  }
}