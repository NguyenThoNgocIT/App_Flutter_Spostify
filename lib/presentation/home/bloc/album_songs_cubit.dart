import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_album_songs.dart';
import 'package:spotify/presentation/home/bloc/album_songs_state.dart';
import 'package:spotify/service_locator.dart';

class AlbumSongsCubit extends Cubit<AlbumSongsState> {
  AlbumSongsCubit() : super(AlbumSongsLoading());

  Future<void> getAlbumSongs(String albumId) async {
    emit(AlbumSongsLoading());
    var result = await sl<GetAlbumSongsUseCase>().call(params: albumId);
    result.fold(
      (error) => emit(AlbumSongsFailure(error)),
      (songs) => emit(AlbumSongsLoaded(songs: songs)),
    );
  }
}