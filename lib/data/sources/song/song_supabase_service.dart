import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/data/models/song/album.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/entities/song/album.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongSupabaseService {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
  Future<Either<String, List<SongEntity>>> getPlayList();
  Future<Either<String, bool>> addOrRemoveFavoriteSong(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs();
  Future<Either<String, List<AlbumEntity>>> getAlbums();
  Future<Either<String, List<SongEntity>>> getAlbumSongs(String albumId);
}

class SongSupabaseServiceImpl implements SongSupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    try {
      final data = await _supabaseClient
          .from('Songs')
          .select()
          .order('releasedate', ascending: false)
          .limit(10);

      final songs = await Future.wait(data.map((element) async {
        var songModel = SongModel.fromJson(Map<String, dynamic>.from(element));
        bool isfavorite = await sl<IsFavoriteSongUseCase>().call(params: element['id']);
        songModel.isfavorite = isfavorite;
        songModel.songid = element['id'];
        return songModel.toEntity();
      }));

      return Right(songs);
    } catch (e) {
      print('Error in getNewsSongs: $e');
      return Left('Không thể tải bài hát mới: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    try {
      final data = await _supabaseClient
          .from('Songs')
          .select()
          .order('releasedate', ascending: false);

      final songs = await Future.wait(data.map((element) async {
        var songModel = SongModel.fromJson(Map<String, dynamic>.from(element));
        bool isfavorite = await sl<IsFavoriteSongUseCase>().call(params: element['id']);
        songModel.isfavorite = isfavorite;
        songModel.songid = element['id'];
        return songModel.toEntity();
      }));

      return Right(songs);
    } catch (e) {
      print('Error in getPlayList: $e');
      return Left('Không thể tải danh sách phát: $e');
    }
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteSong(String songId) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left('Người dùng chưa xác thực');
      }

      String uId = user.id;

      final favoriteSongs = await _supabaseClient
          .from('Favorites')
          .select()
          .eq('userid', uId)
          .eq('songid', songId);

      late bool isFavorite;

      if (favoriteSongs.isNotEmpty) {
        await _supabaseClient
            .from('Favorites')
            .delete()
            .eq('userid', uId)
            .eq('songid', songId);
        isFavorite = false;
      } else {
        await _supabaseClient.from('Favorites').insert({
          'userid': uId,
          'songid': songId,
          'addeddate': DateTime.now().toIso8601String()
        });
        isFavorite = true;
      }

      return Right(isFavorite);
    } catch (e) {
      print('Error in addOrRemoveFavoriteSong: $e');
      return Left('Không thể thêm/xóa bài hát yêu thích: $e');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return false;
      }

      String uId = user.id;

      final favoriteSongs = await _supabaseClient
          .from('Favorites')
          .select()
          .eq('userid', uId)
          .eq('songid', songId);

      return favoriteSongs.isNotEmpty;
    } catch (e) {
      print('Error in isFavoriteSong: $e');
      return false;
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left('Người dùng chưa xác thực');
      }

      String uId = user.id;
      final favorites = await _supabaseClient
          .from('Favorites')
          .select()
          .eq('userid', uId);
      final songIds = favorites.map((e) => e['songid']).toList();

      if (songIds.isEmpty) {
        return Right([]);
      }

      final songs = await _supabaseClient
          .from('Songs')
          .select()
          .inFilter('id', songIds);

      List<SongEntity> favoriteSongs = songs.map((song) {
        SongModel songModel = SongModel.fromJson(Map<String, dynamic>.from(song));
        songModel.isfavorite = true;
        songModel.songid = song['id'];
        return songModel.toEntity();
      }).toList();

      return Right(favoriteSongs);
    } catch (e) {
      print('Error in getUserFavoriteSongs: $e');
      return Left('Không thể tải bài hát yêu thích: $e');
    }
  }

  @override
  Future<Either<String, List<AlbumEntity>>> getAlbums() async {
    try {
      final data = await _supabaseClient
          .from('albums')
          .select()
          .order('releasedate', ascending: false)
          .limit(10);

      final albums = data.map((element) {
        return AlbumModel.fromJson(Map<String, dynamic>.from(element)).toEntity();
      }).toList();

      return Right(albums);
    } catch (e) {
      print('Error in getAlbums: $e');
      return Left('Không thể tải danh sách album: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getAlbumSongs(String albumId) async {
    try {
      final albumSongs = await _supabaseClient
          .from('album_songs')
          .select('song_id')
          .eq('album_id', albumId);

      final songIds = albumSongs.map((e) => e['song_id']).toList();

      if (songIds.isEmpty) {
        return Right([]);
      }

      final songsData = await _supabaseClient
          .from('Songs')
          .select()
          .inFilter('id', songIds);

      final songs = await Future.wait(songsData.map((element) async {
        var songModel = SongModel.fromJson(Map<String, dynamic>.from(element));
        bool isfavorite = await sl<IsFavoriteSongUseCase>().call(params: element['id']);
        songModel.isfavorite = isfavorite;
        songModel.songid = element['id'];
        return songModel.toEntity();
      }));

      return Right(songs);
    } catch (e) {
      print('Error in getAlbumSongs: $e');
      return Left('Không thể tải bài hát của album: $e');
    }
  }
  
}