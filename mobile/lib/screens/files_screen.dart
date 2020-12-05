import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:remote_control/models/files.dart';
import 'package:remote_control/services/request.dart';

final filesProvider = FutureProvider.autoDispose.family<List<File>, String>((ref, path) async {
  final files = await fetchFiles(path);

  ref.maintainState = true;

  return files;
});

class FilesScreen extends ConsumerWidget {
  final String path;

  FilesScreen({ @required this.path });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final title = basename(path);

    return watch(filesProvider(path)).when(
      loading: () {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (err, stack) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
        );
      },
      data: (files) {
        return Scaffold(
            appBar: AppBar(
              title: Text(title.length > 0 ? title : 'Files'),
            ),
            body: files != null && files.length > 0
                ? ListView.builder(itemCount: files.length, itemBuilder: (context, index) => ListItem(files[index]))
                : Center(child: const Text('No items')));
      },
    );
  }
}

class ListItem extends HookWidget {
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
        MaterialPageRoute(builder: (context) => FilesScreen(path: file.path)),
      );
    } else {
      request('files/open', {'path': file.path});
    }
  }
}
