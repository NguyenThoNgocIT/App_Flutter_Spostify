import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/podcast/podcast_supabase_service.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';
import '../../../service_locator.dart';

class PodcastRepositoryImpl extends PodcastsRepository {
  @override
  Future<Either<String, List<PodcastEntity>>> getPodcasts() async {
    return await sl<PodcastSupabaseService>().getPodcasts();
  }
}
