import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/data/models/podcast/podcast.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class PodcastSupabaseService {
  Future<Either<String, List<PodcastEntity>>> getPodcasts();
}

class PodcastSupabaseServiceImpl extends PodcastSupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  Future<Either<String, List<PodcastEntity>>> getPodcasts() async {
    try {
      final data = await _supabaseClient
          .from('Podcasts')
          .select()
          .order('releasedate', ascending: false);
      print('Raw data from Supabase: $data');
      final podcasts = data.map((element) {
        var podcastModel =
            PodcastModel.fromJson(Map<String, dynamic>.from(element));
        podcastModel.podcastid = element['id'];
        return podcastModel.toEntity();
      }).toList();
      print('Parsed podcasts: $podcasts');
      return Right(podcasts);
    } catch (e) {
      print('Error in getPodcasts: $e');
      return Left('Failed to fetch podcasts: $e');
    }
  }
}
