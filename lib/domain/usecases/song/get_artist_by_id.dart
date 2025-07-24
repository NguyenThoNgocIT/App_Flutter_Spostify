// domain/usecases/artist/get_artist_by_id.dart

import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/song/artist.dart';
import 'package:spotify/data/sources/song/song_supabase_service.dart';

class GetArtistByIdUseCase {
  final SongSupabaseService repository;

  GetArtistByIdUseCase(this.repository);

  Future<Either<String, ArtistEntity>> call(String artistId) {
    return repository.getArtistById(artistId);
  }
}
