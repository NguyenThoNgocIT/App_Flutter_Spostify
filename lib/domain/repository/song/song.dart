import 'package:dartz/dartz.dart';

abstract class SongsRepository {

  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
  // ====== Thêm chức năng về Artist ======
  Future<Either> getArtists();
  Future<Either> getArtistById(String id);
}

