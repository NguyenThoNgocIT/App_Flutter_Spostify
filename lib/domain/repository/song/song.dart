import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/entities/song/album.dart';

abstract class SongsRepository {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
  Future<Either<String, List<SongEntity>>> getPlayList();
  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs();
  Future<Either<String, List<AlbumEntity>>> getAlbums();
  Future<Either<String, List<SongEntity>>> getAlbumSongs(String albumId);
}