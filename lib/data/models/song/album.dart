import 'package:spotify/domain/entities/song/album.dart';

class AlbumModel {
  String? id;
  String? title;
  String? artist;
  String? coverfilename;
  DateTime? releasedate;
  int? songCount;

  AlbumModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverfilename,
    required this.releasedate,
    required this.songCount,
  });

  AlbumModel.fromJson(Map<String, dynamic> data) {
    id = data['id']?.toString();
    title = data['title'];
    artist = data['artist'];
    coverfilename = data['coverfilename'];
    releasedate = data['releasedate'] is String
        ? DateTime.parse(data['releasedate'])
        : data['releasedate'];
    songCount = data['song_count'] ?? 0;
  }

  AlbumEntity toEntity() {
    return AlbumEntity(
      id: id ?? 'Unknown ID',
      title: title ?? 'Unknown Title',
      artist: artist ?? 'Unknown Artist',
      coverfilename: coverfilename ?? '',
      releasedate: releasedate ?? DateTime.now(),
      songCount: songCount ?? 0,
    );
  }
}