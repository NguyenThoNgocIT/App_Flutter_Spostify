import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/album.dart';
import 'package:spotify/service_locator.dart';
import '../../repository/song/song.dart';

class GetAlbumsUseCase implements UseCase<Either<String, List<AlbumEntity>>, dynamic> {
  @override
  Future<Either<String, List<AlbumEntity>>> call({dynamic params}) async {
    return await sl<SongsRepository>().getAlbums();
  }
}