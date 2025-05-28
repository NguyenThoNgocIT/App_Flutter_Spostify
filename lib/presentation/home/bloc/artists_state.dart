import 'package:spotify/domain/entities/song/artist.dart';

abstract class ArtistsState {}

class ArtistsInitial extends ArtistsState {}

class ArtistsLoading extends ArtistsState {}

class ArtistsLoaded extends ArtistsState {
  final List<ArtistEntity> artists;

  ArtistsLoaded(this.artists);
}

class ArtistsError extends ArtistsState {
  final String message;

  ArtistsError(this.message);
}
