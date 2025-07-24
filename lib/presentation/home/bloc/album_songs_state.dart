import 'package:equatable/equatable.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class AlbumSongsState extends Equatable {
  const AlbumSongsState();

  @override
  List<Object> get props => [];
}

class AlbumSongsLoading extends AlbumSongsState {}

class AlbumSongsLoaded extends AlbumSongsState {
  final List<SongEntity> songs;

  const AlbumSongsLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class AlbumSongsFailure extends AlbumSongsState {
  final String error;

  const AlbumSongsFailure(this.error);

  @override
  List<Object> get props => [error];
}