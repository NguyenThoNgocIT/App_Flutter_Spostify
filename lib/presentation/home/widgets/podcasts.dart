import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/home/bloc/podcasts_cubit.dart';
import 'package:spotify/presentation/home/bloc/podcasts_state.dart';
import 'package:spotify/presentation/podcast_player/pages/podcast_player.dart';
import '../../../domain/entities/podcast/podcast.dart';

const String defaultImage =
    'https://cdn-icons-png.flaticon.com/512/10542/10542486.png';

class Podcasts extends StatelessWidget {
  const Podcasts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PodcastsCubit()..getPodcasts(),
      child: SizedBox(
        height: 260,
        child: BlocBuilder<PodcastsCubit, PodcastsState>(
          builder: (context, state) {
            if (state is PodcastsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PodcastsLoaded) {
              return _podcasts(state.podcasts);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _podcasts(List<PodcastEntity> podcasts) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PodcastPlayerPage(podcastEntity: podcasts[index]),
              ),
            );
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          AppURLs.getCoverURL(
                                      '${podcasts[index].coverfilename}') !=
                                  ''
                              ? AppURLs.getCoverURL(
                                  '${podcasts[index].coverfilename}')
                              : defaultImage,
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : const Color(0xffE6E6E6),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: context.isDarkMode
                              ? const Color(0xff959595)
                              : const Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  podcasts[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  podcasts[index].host,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemCount: podcasts.length,
    );
  }
}
