import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/song/song_supabase_service.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/entities/song/album.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/service_locator.dart';
import 'package:spotify/domain/entities/song/artist.dart';

class SongRepositoryImpl extends SongsRepository {
  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    return await sl<SongSupabaseService>().getNewsSongs();
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    return await sl<SongSupabaseService>().getPlayList();
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId) async {
    return await sl<SongSupabaseService>().addOrRemoveFavoriteSong(songId);
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    return await sl<SongSupabaseService>().isFavoriteSong(songId);
  }

  @override
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs() async {
    return await sl<SongSupabaseService>().getUserFavoriteSongs();
  }

  @override
  Future<Either<String, List<AlbumEntity>>> getAlbums() async {
    return await sl<SongSupabaseService>().getAlbums();
  }

  @override
  Future<Either<String, List<SongEntity>>> getAlbumSongs(String albumId) async {
    return await sl<SongSupabaseService>().getAlbumSongs(albumId);
  }

  // ====== ARTIST FUNCTIONS (mới thêm) ======
  @override
  Future<Either<String, List<ArtistEntity>>> getArtists() async {
    return await sl<SongSupabaseService>().getArtists();
  }

  @override
  Future<Either<String, ArtistEntity>> getArtistById(String id) async {
    return await sl<SongSupabaseService>().getArtistById(id);
  }
}
