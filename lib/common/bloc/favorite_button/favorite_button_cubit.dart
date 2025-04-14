import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdated(String songid) async {
    var result =
        await sl<AddOrRemoveFavoriteSongUseCase>().call(params: songid);
    result.fold(
      (l) {},
      (isfavorite) {
        emit(FavoriteButtonUpdated(isfavorite: isfavorite));
      },
    );
  }
}
