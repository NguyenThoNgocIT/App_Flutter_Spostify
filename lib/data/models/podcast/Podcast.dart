import 'package:spotify/domain/entities/podcast/podcast.dart';

class PodcastModel {
  String? title;
  String? host;
  dynamic duration; // Có thể là String hoặc num
  DateTime? releasedate;
  String? podcastid;
  String? audioUrl;
  String? coverfilename;

  PodcastModel({
    required this.title,
    required this.host,
    required this.duration,
    required this.releasedate,
    required this.podcastid,
    this.audioUrl,
    this.coverfilename,
  });

  PodcastModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    host = data['host'];
    duration = data['duration'];
    audioUrl = data['audioUrl'];
    coverfilename = data['coverfilename'];
    if (data['releasedate'] is String) {
      releasedate = DateTime.parse(data['releasedate']);
    } else if (data['releasedate'] is DateTime) {
      releasedate = data['releasedate'];
    }
    podcastid = data['id']?.toString();
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

extension PodcastModelX on PodcastModel {
  PodcastEntity toEntity() {
    return PodcastEntity(
      title: title ?? "Unknown Title",
      host: host ?? "Unknown Host",
      releasedate: releasedate ?? DateTime.now(),
      podcastid: podcastid ?? "Unknown ID",
      duration: durationInSeconds,
      audioUrl: audioUrl,
      coverfilename: coverfilename ?? "Unknown Cover",
    );
  }
}
