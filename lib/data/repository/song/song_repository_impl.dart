// import 'package:dartz/dartz.dart';
// import 'package:spotify/data/sources/song/song_firebase_service.dart';
// import 'package:spotify/domain/repository/song/song.dart';

// import '../../../service_locator.dart';

// class SongRepositoryImpl extends SongsRepository {
//   @override
//   Future<Either> getNewsSongs() async {
//     return await sl<SongFirebaseService>().getNewsSongs();
//   }

//   @override
//   Future<Either> getPlayList() async {
//     return await sl<SongFirebaseService>().getPlayList();
//   }

//   @override
//   Future<Either> addOrRemoveFavoriteSongs(String songId) async {
//     return await sl<SongFirebaseService>().addOrRemoveFavoriteSong(songId);
//   }

//   @override
//   Future<bool> isFavoriteSong(String songId) async {
//     return await sl<SongFirebaseService>().isFavoriteSong(songId);
//   }

//   @override
//   Future<Either> getUserFavoriteSongs() async {
//     return await sl<SongFirebaseService>().getUserFavoriteSongs();
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/song/song_supabase_service.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';

import '../../../service_locator.dart';

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
}
