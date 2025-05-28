// domain/usecases/artist/get_artists.dart

import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/song/artist.dart';
import 'package:spotify/data/sources/song/song_supabase_service.dart';

class GetArtistsUseCase {
  final SongSupabaseService repository;

  GetArtistsUseCase(this.repository);

  Future<Either<String, List<ArtistEntity>>> call() {
    return repository.getArtists();
  }
}
