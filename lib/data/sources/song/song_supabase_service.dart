import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import '../../../service_locator.dart';

abstract class SongSupabaseService {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
  Future<Either<String, List<SongEntity>>> getPlayList();
  Future<Either<String, bool>> addOrRemoveFavoriteSong(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs();
}

class SongSupabaseServiceImpl extends SongSupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    try {
      final data = await _supabaseClient
          .from('Songs')
          .select()
          .order('releasedate', ascending: false)
          .limit(3);

      final songs = await Future.wait(data.map((element) async {
        var songModel = SongModel.fromJson(Map<String, dynamic>.from(element));
        bool isfavorite =
            await sl<IsFavoriteSongUseCase>().call(params: element['id']);
        songModel.isfavorite = isfavorite;
        songModel.songid = element['id'];
        return songModel.toEntity();
      }));

      return Right(songs);
    } catch (e) {
      print('Error in getNewsSongs: $e');
      return Left('Failed to fetch new songs: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    try {
      final data = await _supabaseClient
          .from('Songs')
          .select()
          .order('releasedate', ascending: false);
      print("Songs + $data");

      final songs = await Future.wait(data.map((element) async {
        var songModel = SongModel.fromJson(Map<String, dynamic>.from(element));
        bool isfavorite =
            await sl<IsFavoriteSongUseCase>().call(params: element['id']);
        songModel.isfavorite = isfavorite;
        songModel.songid = element['id'];
        return songModel.toEntity();
      }));

      return Right(songs);
    } catch (e) {
      print('Error in getPlayList: $e');
      return Left('Failed to fetch playlist: $e');
    }
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteSong(String songId) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return Left('User not authenticated');
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
      return Left('Failed to add/remove favorite: $e');
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
        return Left('Người dùng chưa được xác thực');
      }

      String uId = user.id;
      final favorites =
          await _supabaseClient.from('Favorites').select().eq('userid', uId);
      final songIds = favorites.map((e) => e['songid']).toList();

      if (songIds.isEmpty) {
        return Right([]);
      }

      final songs =
          await _supabaseClient.from('Songs').select().inFilter('id', songIds);

      List<SongEntity> favoriteSongs = songs.map((song) {
        SongModel songModel =
            SongModel.fromJson(Map<String, dynamic>.from(song));
        songModel.isfavorite = true;
        songModel.songid = song['id'];
        return songModel.toEntity();
      }).toList();

      return Right(favoriteSongs);
    } catch (e) {
      print('Error in getUserFavoriteSongs: $e');
      return Left('Failed to fetch favorite songs: $e');
    }
  }
}
