import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsLoading());

  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    var result = await sl<GetFavoriteSongsUseCase>().call();
    print("getFavoriteSongs");
    print("Favorite Songs:");
    for (var SongEntity in favoriteSongs) {
      print(
          "ID: ${SongEntity.filename}, Title: ${SongEntity.title}, Artist: ${SongEntity.artist}");
    }

    result.fold((l) {
      emit(FavoriteSongsFailure());
    }, (r) {
      favoriteSongs = r;
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    });
  }

  void removeSong(int index) {
    favoriteSongs.removeAt(index);
    emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    print("removeSong" + favoriteSongs.toString());
    // Call the use case to update the favorite songs in the database
    print("Favorite Songs:");
    for (var song in favoriteSongs) {
      print(
          "ID: ${song.filename}, Title: ${song.title}, Artist: ${song.artist}");
    }
  }
}
