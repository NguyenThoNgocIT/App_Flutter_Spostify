class PodcastEntity {
  final String title;
  final String host;
  final num duration;
  final DateTime releasedate;
  final String podcastid;
  final String? audioUrl;
  final String? coverfilename;

  PodcastEntity({
    required this.title,
    required this.host,
    required this.duration,
    required this.releasedate,
    required this.podcastid,
    required this.coverfilename,
    this.audioUrl,
  });
}
