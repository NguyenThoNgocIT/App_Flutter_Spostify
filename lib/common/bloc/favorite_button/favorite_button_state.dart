abstract class FavoriteButtonState {}

class FavoriteButtonInitial extends FavoriteButtonState {}

class FavoriteButtonUpdated extends FavoriteButtonState {
  final bool isfavorite;

  FavoriteButtonUpdated({required this.isfavorite});
}
