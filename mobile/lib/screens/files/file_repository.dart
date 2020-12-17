import 'package:remote_control/services/request.dart';

import 'file.dart';

Future<List<File>> fetchFiles(String path) {
  return requestGet<List<dynamic>>('files/list', {'dir': path})
      .then((response) => [...response.map((json) => File.fromJson(json))]);
}
