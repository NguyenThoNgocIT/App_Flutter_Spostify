
import 'package:flutter/material.dart';
import 'package:spotify/domain/entities/song/artist.dart';
import 'package:spotify/domain/usecases/song/get_artist_by_id.dart';
import 'package:spotify/service_locator.dart';
import 'package:just_audio/just_audio.dart';

class ArtistDetailPage extends StatefulWidget {
  final String artistId;

  const ArtistDetailPage({Key? key, required this.artistId}) : super(key: key);

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  ArtistEntity? _artist;
  bool _isLoading = true;
  String? _error;
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchArtist();
  }

  Future<void> _fetchArtist() async {
    debugPrint('Artist ID: ${widget.artistId}');
    final result = await sl<GetArtistByIdUseCase>().call(widget.artistId);
    setState(() {
      _isLoading = false;
      result.fold(
        (failure) => _error = failure.toString(),
        (artist) {
          _artist = artist;
          debugPrint('Artist: ${_artist!.name}, Songs: ${_artist!.songs.length}');
          for (var song in _artist!.songs) {
            debugPrint('Song: ${song.title}, Cover Filename: ${song.coverfilename}');
          }
        },
      );
    });
  }

  Future<void> _playSong(String? coverFilename) async {
    if (coverFilename == null || coverFilename.isEmpty) {
      print('No cover filename available');
      return;
    }
    // Xây dựng URL từ coverfilename
    final audioUrl = 'https://<your-supabase-project-id>.supabase.co/storage/v1/object/public/songs/$coverFilename';
    print('Playing audio from: $audioUrl'); // Debug URL
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết nghệ sĩ'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Lỗi: $_error'))
              : _artist == null
                  ? const Center(child: Text('Không tìm thấy nghệ sĩ'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: _artist!.imageUrl != null &&
                                          _artist!.imageUrl!.isNotEmpty
                                      ? NetworkImage(_artist!.imageUrl!)
                                      : null,
                                  onBackgroundImageError: (error, stackTrace) {
                                    debugPrint('Lỗi tải hình ảnh: $error');
                                  },
                                  child: _artist!.imageUrl == null ||
                                          _artist!.imageUrl!.isEmpty
                                      ? const Icon(Icons.person, size: 60)
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _artist!.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _artist!.bio ?? 'Không có thông tin mô tả',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          const Text(
                            'Danh sách bài hát',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _artist!.songs.isEmpty
                              ? const Text('Không có bài hát nào.')
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: _artist!.songs.length,
                                    itemBuilder: (context, index) {
                                      final song = _artist!.songs[index];
                                      return ListTile(
                                        leading: Icon(Icons.music_note),
                                        title: Text(song.title),
                                        subtitle: Text(
                                          'Phát hành: ${song.releasedate.toLocal().toString().split(' ')[0]}',
                                        ),
                                        onTap: () {
                                          _playSong(song.coverfilename); // Sử dụng coverfilename để phát nhạc
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
    );
  }
}