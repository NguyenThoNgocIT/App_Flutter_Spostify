import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class PodcastsRepository {
  Future<Either<String, List<PodcastEntity>>> getPodcasts();
}
