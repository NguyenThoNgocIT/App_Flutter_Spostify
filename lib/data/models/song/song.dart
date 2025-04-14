import 'package:spotify/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  dynamic duration; // Có thể là String hoặc num
  DateTime? releasedate;
  bool? isfavorite;
  String? songid;
  String? audioUrl;
  String? filename;
  String? coverfilename;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releasedate,
    required this.isfavorite,
    required this.songid,
    this.audioUrl,
    this.filename,
    this.coverfilename,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration']; // Có thể là String hoặc num
    coverfilename = data['coverfilename'];
    if (data['releasedate'] is String) {
      releasedate = DateTime.parse(data['releasedate']);
    } else if (data['releasedate'] is DateTime) {
      releasedate = data['releasedate'];
    }

    isfavorite = data['isfavorite'] ?? false;
    songid = data['songid']?.toString(); // Sửa từ 'id' thành 'songId'
    filename = data['filename'];
  }

  int get durationInSeconds {
    if (duration == null) return 0;

    if (duration is String) {
      List<String> parts = duration!.split(':');
      if (parts.length != 2) return 0;
      int minutes = int.tryParse(parts[0]) ?? 0;
      int seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    } else if (duration is num) {
      return duration!.toInt();
    }

    return 0;
  }
}

// Đặt extension bên ngoài class
extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title ?? "Unknown Title",
      artist: artist ?? "Unknown Artist",
      releasedate: releasedate ?? DateTime.now(),
      isfavorite: isfavorite ?? false,
      songid: songid ?? "Unknown ID",
      duration: durationInSeconds,
      audioUrl: audioUrl,
      filename: filename,
      coverfilename: coverfilename ?? "Unknown Cover",
    );
  }
}
