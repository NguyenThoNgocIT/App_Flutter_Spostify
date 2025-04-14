class SongEntity {
  final String title;
  final String artist;
  final num duration;
  final DateTime releasedate; // ✅ Đúng
  final bool isfavorite;
  final String songid;
  final String? audioUrl;
  final String? filename;
  final String? coverfilename; // ✅ Đúng

  SongEntity(
      {required this.title,
      required this.artist,
      required this.duration,
      required this.releasedate,
      required this.isfavorite,
      required this.songid,
      required this.coverfilename,
      this.audioUrl,
      this.filename});
}
