import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/podcast/get_podcasts.dart';
import 'package:spotify/presentation/home/bloc/podcasts_state.dart';
import '../../../service_locator.dart';

class PodcastsCubit extends Cubit<PodcastsState> {
  PodcastsCubit() : super(PodcastsLoading());

  Future<void> getPodcasts() async {
    print('Starting to fetch podcasts...');
    var returnedPodcasts = await sl<GetPodcastsUseCase>().call();
    print('Returned podcasts result: $returnedPodcasts');
    returnedPodcasts.fold(
      (l) {
        print('Error fetching podcasts: $l');
        emit(PodcastsLoadFailure());
      },
      (data) {
        print('Fetched podcasts: $data');
        emit(PodcastsLoaded(podcasts: data));
      },
    );
  }
}
