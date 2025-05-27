import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/service_locator.dart';

class GetAlbumSongsUseCase implements UseCase<Either<String, List<SongEntity>>, String> {
  @override
  Future<Either<String, List<SongEntity>>> call({String? params}) async {
    return await sl<SongsRepository>().getAlbumSongs(params!);
  }
}