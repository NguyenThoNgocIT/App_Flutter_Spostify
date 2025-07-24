import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class PodcastsState {}

class PodcastsLoading extends PodcastsState {}

class PodcastsLoaded extends PodcastsState {
  final List<PodcastEntity> podcasts;
  PodcastsLoaded({required this.podcasts});
}

class PodcastsLoadFailure extends PodcastsState {}
