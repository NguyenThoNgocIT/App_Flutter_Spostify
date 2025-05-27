import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/bloc/album_songs_cubit.dart';
import 'package:spotify/presentation/home/bloc/album_songs_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class AlbumDetailPage extends StatelessWidget {
  final String albumId;
  final String albumTitle;

  const AlbumDetailPage({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumSongsCubit()..getAlbumSongs(albumId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(albumTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<AlbumSongsCubit, AlbumSongsState>(
          builder: (context, state) {
            if (state is AlbumSongsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AlbumSongsLoaded) {
              print("Songs loaded: ${state.songs.map((song) => {'title': song.title, 'audioUrl': song.audioUrl, 'filename': song.filename}).toList()}");
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Songs in $albumTitle',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'See More',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xffC6C6C6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _songs(context, state.songs),
                  ],
                ),
              );
            }
            if (state is AlbumSongsFailure) {
              print("Album songs error: ${state.error}");
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Không tìm thấy bài hát nào'));
          },
        ),
      ),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // URL cho hình ảnh bìa
        final coverUrl = songs[index].coverfilename?.isNotEmpty == true
            ? AppURLs.getCoverURL(songs[index].coverfilename!)
            : AppURLs.defaultImage;
        // URL cho tệp âm thanh, ưu tiên filename, nếu null thì thử audioUrl
        String? audioUrl;
        if (songs[index].filename?.isNotEmpty == true) {
          audioUrl = AppURLs.getSongURL(
              songs[index].filename!.replaceFirst(RegExp(r'^/+|/+$'), '').trim());
        } else if (songs[index].audioUrl?.isNotEmpty == true) {
          audioUrl = AppURLs.getSongURL(
              songs[index].audioUrl!.replaceFirst(RegExp(r'^/+|/+$'), '').trim());
        }
        print("Song ${songs[index].title}: audioUrl = $audioUrl, filename = ${songs[index].filename}, audioUrl field = ${songs[index].audioUrl}, coverUrl = $coverUrl");

        return GestureDetector(
          onTap: () async {
            if (audioUrl != null) {
              // Kiểm tra xem URL âm thanh có tồn tại không
              final urlExists = await AppURLs.checkURLExists(audioUrl);
              print("Checking URL: $audioUrl, exists: $urlExists");
              if (urlExists) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SongPlayerPage(
                      songEntity: songs[index],
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tệp bài hát không tồn tại: $audioUrl')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Không tìm thấy tệp bài hát cho ${songs[index].title}')),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      coverUrl,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading song cover for ${songs[index].title}: $error');
                        return Image.network(
                          AppURLs.defaultImage,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        songs[index].artist,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    _formatDuration(songs[index].duration),
                  ),
                  const SizedBox(width: 20),
                  FavoriteButton(songEntity: songs[index]),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: songs.length,
    );
  }

  String _formatDuration(num duration) {
    final intDuration = duration.toInt();
    final minutes = intDuration ~/ 60;
    final seconds = intDuration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}