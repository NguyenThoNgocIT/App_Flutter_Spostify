import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageDebugger extends StatefulWidget {
  const SupabaseStorageDebugger({Key? key}) : super(key: key);

  @override
  State<SupabaseStorageDebugger> createState() =>
      _SupabaseStorageDebuggerState();
}

class _SupabaseStorageDebuggerState extends State<SupabaseStorageDebugger> {
  final supabase = Supabase.instance.client;
  List<FileObject> _files = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedBucket = 'songs-covers';
  String _currentPath = '';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response =
          await supabase.storage.from(_selectedBucket).list(path: _currentPath);

      setState(() {
        _files = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách file: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToFolder(String folderName) {
    setState(() {
      _currentPath =
          _currentPath.isEmpty ? folderName : '$_currentPath/$folderName';
    });
    _loadFiles();
  }

  void _navigateUp() {
    if (_currentPath.isEmpty) return;

    final parts = _currentPath.split('/');
    if (parts.length <= 1) {
      setState(() {
        _currentPath = '';
      });
    } else {
      parts.removeLast();
      setState(() {
        _currentPath = parts.join('/');
      });
    }
    _loadFiles();
  }

  void _testFileURL(FileObject file) async {
    final String url = supabase.storage
        .from(_selectedBucket)
        .getPublicUrl('$_currentPath/${file.name}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL: $url'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy to clipboard logic
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supabase Storage Debugger'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          // Path navigator
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                if (_currentPath.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _navigateUp,
                  ),
                Expanded(
                  child: Text(
                    'Path: $_selectedBucket/${_currentPath.isEmpty ? '' : _currentPath}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.red.shade100,
              width: double.infinity,
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _files.isEmpty
                    ? const Center(child: Text('Không có file nào'))
                    : ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          final file = _files[index];
                          final isFolder = file.metadata == null;

                          return ListTile(
                            leading: Icon(
                              isFolder ? Icons.folder : Icons.insert_drive_file,
                              color: isFolder ? Colors.amber : Colors.blue,
                            ),
                            title: Text(file.name),
                            subtitle: !isFolder
                                ? Text(
                                    '${(file.metadata?['size'] ?? 0) / 1024} KB')
                                : null,
                            onTap: isFolder
                                ? () => _navigateToFolder(file.name)
                                : () => _testFileURL(file),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
