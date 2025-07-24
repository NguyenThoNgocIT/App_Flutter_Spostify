import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_albums.dart';
import 'package:spotify/presentation/home/bloc/album_state.dart';
import 'package:spotify/service_locator.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit() : super(AlbumLoading());

  Future<void> getAlbums() async {
    var returnedAlbums = await sl<GetAlbumsUseCase>().call();
    returnedAlbums.fold(
      (error) => emit(AlbumLoadFailure(error)),
      (albums) => emit(AlbumLoaded(albums: albums)),
    );
  }
}