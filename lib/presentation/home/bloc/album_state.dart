import 'package:equatable/equatable.dart';
import 'package:spotify/domain/entities/song/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<AlbumEntity> albums;

  const AlbumLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

class AlbumLoadFailure extends AlbumState {
  final String error;

  const AlbumLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}