import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/song/album.dart';
import 'package:spotify/presentation/home/bloc/album_cubit.dart';
import 'package:spotify/presentation/home/bloc/album_state.dart';
import 'package:spotify/presentation/album/pages/album_detail.dart'; // Import AlbumDetailPage

class Album extends StatelessWidget {
  const Album({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit()..getAlbums(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<AlbumCubit, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AlbumLoaded) {
              return _albums(context, state.albums);
            }
            if (state is AlbumLoadFailure) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Chưa có album nào'));
          },
        ),
      ),
    );
  }

  Widget _albums(BuildContext context, List<AlbumEntity> albums) {
    if (albums.isEmpty) {
      return const Center(child: Text('Chưa có album nào'));
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Chuyển hướng sang AlbumDetailPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AlbumDetailPage(
                  albumId: albums[index].id, // Truyền albumId
                  albumTitle: albums[index].title, // Truyền albumTitle
                ),
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
                          albums[index].coverfilename.isNotEmpty
                              ? AppURLs.getCoverURL(albums[index].coverfilename)
                              : AppURLs.defaultImage,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  albums[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  albums[index].artist,
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
      itemCount: albums.length,
    );
  }
}