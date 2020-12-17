import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:remote_control/screens/files/file.dart';
import 'package:remote_control/services/request.dart';

import 'file_repository.dart';

class FilesScreen extends StatefulWidget {
  final String path;

  FilesScreen({@required this.path});

  @override
  FilesScreenState createState() => FilesScreenState();
}

class FilesScreenState extends State<FilesScreen> {
  Future<List<File>> files;
  String title;

  @override
  void initState() {
    title = basename(widget.path);
    files = fetchFiles(widget.path);
    super.initState();
  }

  refresh() {
    setState(() {
      files = fetchFiles(widget.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
        future: files,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.error != null) {
            return Scaffold(appBar: AppBar(title: const Text('Error')));
          }

          final files = snapshot.data;

          return Scaffold(
              appBar: AppBar(title: Text(title.length > 0 ? title : 'Files')),
              body: files != null && files.length > 0
                  ? ListView(children: files.map((file) => ListItem(file)).toList())
                  : Center(child: const Text('No items')));
        });
  }
}

class ListItem extends StatelessWidget {
  final File file;

  ListItem(this.file);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${file.name}'),
      onTap: () => onTap(context),
    );
  }

  onTap(BuildContext context) {
    if (file.isDirectory) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FilesScreen(path: file.path)),
      );
    } else {
      request('files/open', {'path': file.path});
    }
  }
}
