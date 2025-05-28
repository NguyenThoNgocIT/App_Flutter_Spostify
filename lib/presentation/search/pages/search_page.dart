import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/bloc/play_list_cubit.dart';
import 'package:spotify/presentation/home/bloc/play_list_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _searchHistory = [];
  String _searchQuery = '';

  void _addSearchTerm(String term) {
    if (term.isEmpty) return;
    setState(() {
      if (_searchHistory.contains(term)) {
        _searchHistory.remove(term);
      }
      _searchHistory.insert(0, term);
      _searchQuery = term;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => PlayListCubit()..getPlayList(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onSubmitted: (value) {
                  _addSearchTerm(value);
                },
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<PlayListCubit, PlayListState>(
                  builder: (context, state) {
                    if (state is PlayListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PlayListLoaded) {
                      // Lọc bài hát dựa trên từ khóa tìm kiếm
                      final filteredSongs = _searchQuery.isEmpty
                          ? <SongEntity>[]
                          : state.songs.where((song) {
                              return song.title
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase()) ||
                                  song.artist
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase());
                            }).toList();

                      if (_searchQuery.isEmpty) {
                        // Hiển thị lịch sử tìm kiếm khi không có từ khóa
                        return ListView(
                          children: _searchHistory
                              .map(
                                (term) => ListTile(
                                  title: Text(term),
                                  leading: const Icon(Icons.history),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _searchHistory.remove(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    _addSearchTerm(term);
                                    _controller.text = term;
                                  },
                                ),
                              )
                              .toList(),
                        );
                      }

                      if (filteredSongs.isEmpty) {
                        return const Center(
                          child: Text('Không tìm thấy bài hát nào.'),
                        );
                      }

                      // Hiển thị kết quả tìm kiếm
                      return _songs(context, filteredSongs);
                    }
                    return const Center(child: Text('Đã xảy ra lỗi.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayerPage(
                  songEntity: songs[index],
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
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
                    songs[index].duration.toString().replaceAll('.', ':'),
                  ),
                  const SizedBox(width: 20),
                  FavoriteButton(
                    songEntity: songs[index],
                  ),
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
}

// Phi Đen