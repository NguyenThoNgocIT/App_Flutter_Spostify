class AlbumEntity {
  final String id;
  final String title;
  final String artist;
  final String coverfilename;
  final DateTime releasedate;
  final int songCount;

  AlbumEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverfilename,
    required this.releasedate,
    required this.songCount,
  });
}