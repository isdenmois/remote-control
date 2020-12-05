import 'package:dio/dio.dart';
import '../models/files.dart';

final baseUrl = 'http://192.168.1.60:3000';

Future<T> requestGet<T>(String type, [ Map<String, dynamic> queryParameters ]) {
  return Dio().get<T>('$baseUrl/$type', queryParameters: queryParameters).then((response) => response.data).catchError((
      e) {
    print(e);
    return null;
  });
}

Future<T> request<T>(String type, [ Map<String, dynamic> queryParameters ]) {
  return Dio().post<T>('$baseUrl/$type', queryParameters: queryParameters)
      .then((response) => response.data)
      .catchError((e) {
    print(e);
    return null;
  });
}

Future keyPress(String key) {
  return request('keypress', {'key': key});
}

Future<List<File>> fetchFiles(String path) {
  return requestGet<List<dynamic>>('files/list', {'dir': path})
      .then((response) => [...response.map((json) => File.fromJson(json))]);
}
