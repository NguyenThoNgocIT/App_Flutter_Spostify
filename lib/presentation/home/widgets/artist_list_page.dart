import 'package:flutter/material.dart';
import 'package:spotify/domain/entities/song/artist.dart';
import 'package:spotify/domain/usecases/song/get_artists.dart';
import 'package:spotify/service_locator.dart';

import '../pages/artist_detail_page.dart';

class ArtistListPage extends StatefulWidget {
  const ArtistListPage({Key? key}) : super(key: key);

  @override
  State<ArtistListPage> createState() => _ArtistListPageState();
}

class _ArtistListPageState extends State<ArtistListPage> {
  List<ArtistEntity> _artists = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  Future<void> _fetchArtists() async {
    final result = await sl<GetArtistsUseCase>().call();
    result.fold(
      (failure) => setState(() {
        _error = failure;
        _isLoading = false;
      }),
      (artists) => setState(() {
        _artists = artists;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Lỗi: $_error'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nghệ sĩ'),
      ),
      body: ListView.builder(
        itemCount: _artists.length,
        itemBuilder: (context, index) {
          final artist = _artists[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(artist.imageUrl ?? ''),
            ),
            title: Text(artist.name),
            subtitle: Text(artist.bio ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArtistDetailPage(artistId: artist.artistId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
