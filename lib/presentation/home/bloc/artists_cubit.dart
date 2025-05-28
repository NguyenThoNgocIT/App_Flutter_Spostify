import 'package:bloc/bloc.dart';
import 'package:spotify/domain/usecases/song/get_artists.dart';
import 'package:spotify/service_locator.dart';

import 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final GetArtistsUseCase _getArtistsUseCase = sl<GetArtistsUseCase>();

  ArtistsCubit() : super(ArtistsInitial());

  Future<void> fetchArtists() async {
    emit(ArtistsLoading());
    final result = await _getArtistsUseCase.call();

    result.fold(
      (failure) => emit(ArtistsError(failure)),
      (artists) => emit(ArtistsLoaded(artists)),
    );
  }
}
